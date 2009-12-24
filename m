Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZLXFKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZLXFKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZLXFKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:10:34 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:38708 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZLXFKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:10:33 -0500
X-Greylist: delayed 1920 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Dec 2009 00:10:33 EST
From: Samir Bellabes <sam@synack.fr>
To: Michael Stone <michael@laptop.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-15?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/3] Security: Add prctl(PR_{GET,SET}_NETWORK) interface. (v3)
References: <20091224014454.GA24161@heat>
Date: Thu, 24 Dec 2009 05:38:30 +0100
In-Reply-To: <20091224014454.GA24161@heat> (Michael Stone's message of "Wed,
	23 Dec 2009 20:44:54 -0500")
Message-ID: <m2pr653s1l.fsf@ssh.synack.fr>
User-Agent: Gnus/5.110003 (No Gnus v0.3) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone <michael@laptop.org> writes:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f2f842d..0c65c55 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1402,6 +1402,8 @@ struct task_struct {
>   	unsigned int sessionid;
>   #endif
>   	seccomp_t seccomp;
> +/* Flags for limiting networking via prctl(PR_SET_NETWORK). */
> +  unsigned long network;
>   
>   /* Thread group tracking */
>      	u32 parent_exec_id;

I think this is unnecessary, as LSM module, you should use the
void* security member of the structure cred. 

this member allows you to mark task_struct as you which, it's a kind of
abstraction provided to all security modules.
