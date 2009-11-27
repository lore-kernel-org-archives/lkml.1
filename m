Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZK0Weo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZK0Weo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZK0Wen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:34:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44232 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZK0Wem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:34:42 -0500
To: andrew hendry <andrew.hendry@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-x25@vger.kernel.org
References: <d45a3acc0911241715jcb41224y7871ea0878b9df9e@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 27 Nov 2009 14:34:44 -0800
In-Reply-To: <d45a3acc0911241715jcb41224y7871ea0878b9df9e@mail.gmail.com> (andrew hendry's message of "Wed\, 25 Nov 2009 12\:15\:26 +1100")
Message-ID: <m1fx7ztx4r.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;andrew hendry <andrew.hendry@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 1/3] X25: Move SYSCTL ifdefs into header
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andrew hendry <andrew.hendry@gmail.com> writes:

> Moves the CONFIG_SYSCTL ifdefs in x25_init into header.

This looks like a reasonable change and it doesn't conflict
with my pending changes in the sysctl tree.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>
>
> diff -uprN -X a/Documentation/dontdiff a/include/net/x25.h b/include/net/x25.h
> --- a/include/net/x25.h	2009-11-10 11:32:31.000000000 +1100
> +++ b/include/net/x25.h	2009-11-25 09:05:21.000000000 +1100
> @@ -287,8 +287,14 @@ extern unsigned long x25_display_timer(s
>  extern void x25_check_rbuf(struct sock *);
>
>  /* sysctl_net_x25.c */
> +#ifdef CONFIG_SYSCTL
>  extern void x25_register_sysctl(void);
>  extern void x25_unregister_sysctl(void);
> +#else
> +static inline void x25_register_sysctl(void) {};
> +static inline void x25_unregister_sysctl(void) {};
> +#endif /* CONFIG_SYSCTL */
> +
>  struct x25_skb_cb {
>  	unsigned flags;
>  };
> diff -uprN -X a/Documentation/dontdiff a/net/x25/af_x25.c b/net/x25/af_x25.c
> --- a/net/x25/af_x25.c	2009-11-17 10:30:18.000000000 +1100
> +++ b/net/x25/af_x25.c	2009-11-25 09:04:25.000000000 +1100
> @@ -1667,9 +1667,7 @@ static int __init x25_init(void)
>
>  	printk(KERN_INFO "X.25 for Linux Version 0.2\n");
>
> -#ifdef CONFIG_SYSCTL
>  	x25_register_sysctl();
> -#endif
>  	x25_proc_init();
>  out:
>  	return rc;
> @@ -1682,9 +1680,7 @@ static void __exit x25_exit(void)
>  	x25_link_free();
>  	x25_route_free();
>
> -#ifdef CONFIG_SYSCTL
>  	x25_unregister_sysctl();
> -#endif
>
>  	unregister_netdevice_notifier(&x25_dev_notifier);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
