Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYLERQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYLERQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbYLERQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:16:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46120 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYLERQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:16:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
References: <20081203191706.GA16433@us.ibm.com>
	<20081203191733.GA16652@us.ibm.com>
Date: Fri, 05 Dec 2008 09:14:05 -0800
In-Reply-To: <20081203191733.GA16652@us.ibm.com> (Serge E. Hallyn's message of
	"Wed, 3 Dec 2008 13:17:33 -0600")
Message-ID: <m1r64mpmsi.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/2] user namespaces: require cap_set{ug}id for CLONE_NEWUSER
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> While ideally CLONE_NEWUSER will eventually require no
> privilege, the required permission checks are currently
> not there.  As a result, CLONE_NEWUSER has the same effect
> as a setuid(0)+setgroups(1,"0").  While we already require
> CAP_SYS_ADMIN, requiring CAP_SETUID and CAP_SETGID seems
> appropriate.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

The patch looks good, and we are likely to need more caps to
actually use it.
 
>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  kernel/fork.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 1dd8945..e3a85b3 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1344,7 +1344,8 @@ long do_fork(unsigned long clone_flags,
>  		/* hopefully this check will go away when userns support is
>  		 * complete
>  		 */
> -		if (!capable(CAP_SYS_ADMIN))
> +		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SETUID) ||
> +				!capable(CAP_SETGID))
>  			return -EPERM;
>  	}
>  
> -- 
> 1.5.4.3
