Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYFRV66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYFRV66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYFRV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:58:35 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:51236 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754254AbYFRV6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:58:34 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes
Date: Thu, 19 Jun 2008 00:58:28 +0300
User-Agent: KMail/1.9.9
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
References: <20080618194917.GC2741@infomag.infomag.iguana.be> <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806190058.29330.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus;

18 Haz 2008 Çar tarihinde, Linus Torvalds şunları yazmıştı: 
> 
> On Wed, 18 Jun 2008, Wim Van Sebroeck wrote:
> > 
> >     Revert "[WATCHDOG] hpwdt: Fix NMI handling."
> >     
> >     To get this driver working we need the CFLAGS_hpwdt.o += -O in the Makefile.
> >
> >     The driver needs the asmlinkage tag and the CFLAGS line in the Makefile.
> >     Without it the driver doesn't work.
> 
> The driver is unbelievable shit, and should just be removed, I think.
> 
> The reason for all the games with CFLAGS and asmlinkage and utter crud 
> seems to be that the driver is just BROKEN. It will work purely by luck, 
> and depend entirely on the compiler not doing anything else AT ALL in that 
> asm function.
> 
> Could somebody please just fix the piece-of-sh*t thing?
> 
> Here's a totally untested patch that may or may not work. At least it 
> removes the assembler code that assumes that it controls the whole 
> function from anything that gcc will then create a function prologue and 
> epilogue for. Quite frankly, this is *not* the right thing to do either: 
> the proper thing to do is to just move the low-level call into the "asm" 
> statement, and leave all the function prologue/epilogue entirely to the 
> compiler.
> 
> But this way it isn't actively _broken_ by design, at least.
> 
> No promises. I don't have the hardware. But somebody should *really* do 
> this correctly.


I have both the hardware and the compiler related (gcc-4.3.1) bug :) (see [1])

Your modifications works like a charm with 32bit 2.6.25.7, kernel no longer opps and watchdog lives happily with hardware.

[...]
hpwdt: New timer passed in is 30 seconds.
hpwdt: CRU Base Address:   0xfff6b800
hpwdt: CRU Offset Address: 0x0
hpwdt: CRU Length:         0x8000
hpwdt: CRU Mapped Address: 0xf885bfa8
hp Watchdog Timer Driver: 1.00, timer margin: 30 seconds( nowayout=0).
[...]
 
> 		Linus
> 
> ---
>  drivers/watchdog/hpwdt.c |  155 ++++++++++++++++++++++++----------------------
>  1 files changed, 80 insertions(+), 75 deletions(-)

If needed 

Tested-by: S.Çağlar Onur <caglar@pardus.org.tr>

Thanks!

[1] http://marc.info/?l=linux-kernel&m=121266952602497&w=2
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
