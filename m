Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbXKTJYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbXKTJYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbXKTJYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:24:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:29622 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbXKTJYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:reply-to:organization:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=e9s+OdMJ6klyrUlw7S1+LGRQ+8kAAN6WevvDcrKDfT1JBLCrNuwJ8S8qpw0sC5rVvrqJ/N0hGUrbEXV9U1X+zNMLonG6X3g8/ZxxK4UfBhwsM8Nr7gkU3ynCz5Np2CcmVhVXjhSzzwdUu0BiRMjlwnDPCMUXGhPHY1QpUIineCQ=
From: David <david@livux.com>
Reply-To: david@livux.com
Organization: LiVux
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8,v2.6.22.13, v2.6.21.7
Date: Tue, 20 Nov 2007 10:23:47 +0100
User-Agent: KMail/1.9.7
References: <200711191925.12072.david@livux.com> <200711192239.51301.david@livux.com> <20071120061302.GH20436@elte.hu>
In-Reply-To: <20071120061302.GH20436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711201023.47614.david@livux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Martes, 20 de Noviembre de 2007, Ingo Molnar escribió:
> * David <david@livux.com> wrote:
> > El Lunes, 19 de Noviembre de 2007, Ingo Molnar escribió:
> > > * David <david@livux.com> wrote:
> > > > I have removed all other patches, and applied only cfs v24 above
> > > > 2.6.23.8, and the compiler ran into (with CONFIG_FAIR_GROUP_SCHED
> > > > enabled):
> > >
> > > does the patch below help?
> > >
> > > 	Ingo
> >
> > Yes, now sched.c compile without errors, but linking fails at:
> >
> >
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > kernel/built-in.o:(.data+0x4a8): undefined reference to
> > `sysctl_sched_min_bal_int_shares' kernel/built-in.o:(.data+0x4d4):
> > undefined reference to `sysctl_sched_max_bal_int_shares' make: ***
> > [.tmp_vmlinux1] Error 1
>
> does the patch below do the trick?
>
> 	Ingo
>
> Index: linux/kernel/sysctl.c
> ===================================================================
> --- linux.orig/kernel/sysctl.c
> +++ linux/kernel/sysctl.c
> @@ -309,7 +309,7 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> -#ifdef CONFIG_FAIR_GROUP_SCHED
> +#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "sched_min_bal_int_shares",

Yes, the kernel compile correctly.

Thanks Ingo



-- 
David Rodríguez García
Director Técnico
LiVux I+D S.L.
