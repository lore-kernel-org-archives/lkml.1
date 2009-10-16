Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZJPJnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZJPJnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbZJPJnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:43:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50559 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbZJPJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:43:10 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, rjw@sisk.pl, htmldeveloper@gmail.com,
       linux-kernel@vger.kernel.org
References: <bug-14408-10286@http.bugzilla.kernel.org/>
	<20091015132323.bea94a13.akpm@linux-foundation.org>
	<m1tyy0i7tm.fsf@fess.ebiederm.org> <20091016002837.GA4185@x200>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 16 Oct 2009 02:42:25 -0700
In-Reply-To: <20091016002837.GA4185@x200> (Alexey Dobriyan's message of "Fri\, 16 Oct 2009 04\:28\:37 +0400")
Message-ID: <m1k4yvisji.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] sysctl: fix false positives when PROC_SYSCTL=n
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> Having ->procname but not ->proc_handler is valid when PROC_SYSCTL=n,
> people use such combination to reduce ifdefs with non-standard handlers.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=14408

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

It looks like I messed up when I wrote sysctl_check.c and used the
wrong ifdef.  Silly me.  Especially since I had added PROC_SYSCTL
earlier.

Eric


> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>
>  kernel/sysctl_check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -1521,7 +1521,7 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
>  			if (!table->ctl_name && table->strategy)
>  				set_fail(&fail, table, "Strategy without ctl_name");
>  #endif
> -#ifdef CONFIG_PROC_FS
> +#ifdef CONFIG_PROC_SYSCTL
>  			if (table->procname && !table->proc_handler)
>  				set_fail(&fail, table, "No proc_handler");
>  #endif
