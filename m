Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYFDABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYFDABr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYFDABi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:01:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:15423 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYFDABg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:01:36 -0400
X-BigFish: VPS-32(z34a4nz1432R98dR7efV1805Mzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4845DB46.3020308@am.sony.com>
Date: Tue, 3 Jun 2008 17:01:10 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
References: <48447615.5050806@am.sony.com> <1212500751.16924.322.camel@pmac.infradead.org>
In-Reply-To: <1212500751.16924.322.camel@pmac.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2008 00:01:23.0030 (UTC) FILETIME=[1FFB5F60:01C8C5D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Mon, 2008-06-02 at 15:37 -0700, Tim Bird wrote:
>> With CONSOLE_TRANSLATIONS turned off, this saves about 6K
>> on my kernel configured for an ARM development board (OMAP
>> 5912 OSK).  In embedded products I'm familiar with,
>> console translations are not needed.
>>
>> This was taken from the Linux-tiny project and updated slightly
>> for 2.6.25.
> 
> I prefer it like this... we can drop consolemap.o and
> consolemap_deftbl.o from the build completely. It saves 7.2KiB on a
> ppc32 build here.
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 595a925..f740190 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> ...

This is clearly an improvement. But it is missing this part of the
original patch:

--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2198,7 +2198,11 @@ rescan_last_byte:
 			c = 0xfffd;
 		    tc = c;
 		} else {	/* no utf or alternate charset mode */
+#ifdef CONFIG_CONSOLE_TRANSLATIONS
 		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
+#else
+		    tc = c;
+#endif
 		}

                 /* If the original code was a control character we

With the set_translate function stubbed, and the actual translation
operation left intact, I think the code might have problems.

I ran your patch fine on my OSK board here, but I must not have hit a
character translation case.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

