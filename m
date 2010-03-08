Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0CHUV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:21:26 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:40792 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0CHUVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:21:20 -0500
Date: Mon, 8 Mar 2010 21:21:10 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, nikola.ciprich@linuxbox.cz
Subject: Re: [Bug #14943] nfs regression?
Message-ID: <20100308202110.GA4731@nik-comp.linuxbox.cz>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
 <wj3ZQZlk_KB.A.M6B.QsagLB@chimera>
 <2375c9f91002211813m8f637c1g73c4314eab96f81e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f91002211813m8f637c1g73c4314eab96f81e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Milter-Copy-Status: O
X-Milter-Copy-Status: O
X-Milter-Copy-Status: L
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3509228 records(08-03-2010)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YES!
seems like 2.6.32.8 with your patch included finally doesn't
spit any backtraces and peername failed errors!
will You push this upstream + to stable?
thanks a lot for Your help!
have a nice day
with best regards
nik

> This seems that we missed checking XPT_DEAD too.
> 
> Nikola, does adding !test_bit(XPT_DEAD, &xprt->xpt_flags) in the same
> place as commit b292cf9ce70d221c3f04f help?
> 
> Something like:
> 
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index 7d1f9e9..7b66c7f 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -700,7 +700,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
> 
>         len = 0;
>         if (test_bit(XPT_LISTENER, &xprt->xpt_flags) &&
> -           !test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
> +           !test_bit(XPT_CLOSE, &xprt->xpt_flags) &&
> +           !test_bit(XPT_DEAD, &xprt->xpt_flags)) {
>                 struct svc_xprt *newxpt;
>                 newxpt = xprt->xpt_ops->xpo_accept(xprt);
>                 if (newxpt) {
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
