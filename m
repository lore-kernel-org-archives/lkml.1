Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbXI0QfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbXI0QfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXI0QfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:35:07 -0400
Received: from SOKENS04e.snapon.com ([217.33.151.229]:40604 "EHLO
	sokens04.snapon.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491AbXI0QfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:35:05 -0400
Message-ID: <00e101c80124$32ef67a0$7502a8c0@snaponglobal.com>
From: "Marco Tralli" <marco.tralli@snapon.com>
To: "Juergen Beisert" <juergen127@kreuzholzen.de>,
       <linux-kernel@vger.kernel.org>
Cc: "Jordan Crouse" <jordan.crouse@amd.com>
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com> <200709271813.26103.juergen127@kreuzholzen.de>
Subject: Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Thu, 27 Sep 2007 18:33:45 +0200
Organization: SNAPON
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1807
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
X-OriginalArrivalTime: 27 Sep 2007 16:35:01.0711 (UTC) FILETIME=[59CCE5F0:01C80124]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Juergen,

> It runs stable on 5 different GX1 systems.
>
> But I do not use a standard BIOS. I'm using LinuxBIOS instead. But I'm
also using
> these patches.
>

set_cx86_inc was one of performance trick called by geode_configure
I didn't find any documentation about "incrementor margin" before.

But since I'm running on 300MHz GX1 the default kernel is now broken for me!


> --- linux-2.6.22.orig/arch/i386/kernel/cpu/cyrix.c
> +++ linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
> @@ -169,7 +169,7 @@ static void __cpuinit set_cx86_inc(void)
>   setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
>   /* PCR0 -- Performance Control */
>   /* Incrementor Margin 10 */
> - setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
> + setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x05); /* 300MHz CPU */
>   setCx86(CX86_CCR3, ccr3); /* disable MAPEN */
>  }
>

I will try your patch

But again, if those tricks are so system dependent  I suggest to kernel
people to let disable it in default configuration.


Marco

