Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYDBIaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYDBIaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYDBIa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:30:26 -0400
Received: from dns0.mips.com ([63.167.95.198]:43734 "EHLO dns0.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYDBIaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:30:25 -0400
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 04:30:24 EDT
Message-ID: <47F33C6B.9050704@mips.com>
Date: Wed, 02 Apr 2008 09:57:31 +0200
From: "Kevin D. Kissell" <kevink@mips.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/MIPS Development <linux-mips@linux-mips.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: max_pfn: Uninitialized, or Deprecated?
References: <47F1F349.7010503@mips.com> <Pine.LNX.4.64.0804020910290.14383@anakin>
In-Reply-To: <Pine.LNX.4.64.0804020910290.14383@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch you point to will maybe solve some initrd problems,
but I think it's treating a symptom rather than the cause.  There
is other code, both generic and MIPS-specific (the APRP stuff),
that assumes that max_pfn is meaningful.  Either we have to hunt
down and kill those instances (not really hard, but requiring several
maintainers working in concert) or we see to it that MIPS provides
a usable value.  A value of 0 causes the system to treat the beginning
of kseg0 as "out of band" memory, which may work some of the time
for MIPSxxR2 processors, where the cacheable execption vector
base is set up to be beyond the kernel image, but for older processors
where the vectors are at the beginning of kseg0...

          Regards,

          Kevin K.

Geert Uytterhoeven wrote:
> On Tue, 1 Apr 2008, Kevin D. Kissell wrote:
>   
>> Once upon a time, the global max_pfn value was set up as part of
>> bootmem_init(), but this seems to have been dropped in favor of
>> establishing max_low_pfn, I suppose to be clear that it's the max
>> non-highmem PFN.  However, the global max_pfn gets used in
>> the MIPS APRP support code,  and also in places like
>> block/blk-settings.c.  Is the use of max_pfn supposed to be
>> deprecated, such that we consider blk-settings.c to be broken
>> and change arch/mips/kernel/vpe.c to use max_low_pfn, or
>> ought we assign  max_pfn = max_low_pfn in bootmem_init()?
>>     
>
> I noticed this too when investigating why initrds no longer worked on
> m68k (Fix in http://lkml.org/lkml/2007/12/23/36, still not in mainline).
>
> Apparently a value of max_pfn = 0 is OK, as several architectures
> (including MIPS and m68k) don't touch it?
>
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
>
>   
