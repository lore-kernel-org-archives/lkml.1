Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZLUOcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZLUOcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZLUOcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:32:05 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54832 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZLUOcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rbc9LzapsM65+EBkoMuXTbich/RJ3c1CmclsCP0PYRg+oQDXYmRg0nwAF5ZPavsSEK
         OanQVLqxtMASvSVvpRNXTYb8K6Ucr3pwU7FIYuhrZ6bngEhEDRQTydU3IOGMPBV9+vp+
         A++ShR/TrlapAwVtAw8vL8KZsu7rhC15jzbzU=
MIME-Version: 1.0
In-Reply-To: <20091221140533.GA14468@aftab>
References: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
	 <64bb37e0912191154n4a7ea5benbb3da57f1aabdbe6@mail.gmail.com>
	 <64bb37e0912200953j2046a935n2f9ecd2cdfed780f@mail.gmail.com>
	 <20091220191436.GA3982@liondog.tnic>
	 <64bb37e0912201136m5bd46867s73ddc43c85f80b38@mail.gmail.com>
	 <64bb37e0912201140i772c8484h4662c2fea15a921a@mail.gmail.com>
	 <20091221140533.GA14468@aftab>
Date: Mon, 21 Dec 2009 15:31:59 +0100
Message-ID: <64bb37e0912210631r1cea318cv2fd8cce42485c24a@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc1
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 3:05 PM, Borislav Petkov
<borislav.petkov@amd.com> wrote:
> On Sun, Dec 20, 2009 at 08:40:53PM +0100, Torsten Kaiser wrote:
>> [    4.697308] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 838: F2x090 (DRAM Cfg Low): 0x00080810
>> [    4.697311] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 842:   DIMM type: buffered; all DIMMs support ECC: yes
>> [    4.697313] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 845:   PAR/ERR parity: disabled
>> [    4.697315] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 848:   DCT 128bit mode width: 128b
>> [    4.697317] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 854:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
>> [    4.697319] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 873: F3xB0 (Online Spare): 0x0f000000
>> [    4.697322] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 880: F1xF0 (DRAM Hole Address): 0x00000000, base: 0x00000000, offset: 0x00000000
>> [    4.697324] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 883:   DramHoleValid: no
>> [    4.697327] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1716: F2x080 (DRAM Bank Address Mapping): 0x00000002
>> [    4.697328] EDAC MC: DCT0 chip selects:
>> [    4.697330] EDAC MC:  0:   512MB 1:   512MB
>> [    4.697331] EDAC MC:  2:     0MB 3:     0MB
>> [    4.697333] EDAC MC:  4:     0MB 5:     0MB
>> [    4.697334] EDAC MC:  6:     0MB 7:     0MB
>
> Yes, you're correct. The DRAM controller is running in 128bit mode
> and we should account for that. Turns out that there's more clumsy
> stuff going on in the code wrt to channel accounting and I'll fix this
> properly when I get the chance. Here's a temporary fix for now which
> should solve your issue.

Yes, with your patch it looks correct:
[    4.632982] EDAC MC: Ver: 2.1.0 Dec 21 2009
[    4.638831] EDAC amd64_edac:  Ver: 3.3.0 Dec 21 2009
[    4.645385] EDAC amd64: ECC is enabled by BIOS.
[    4.651529] EDAC amd64: ECC is enabled by BIOS.
[    4.657709] EDAC MC: Rev F or later detected
[    4.657718] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
[    4.665856] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
[    4.673958] EDAC MC: DCT0 chip selects:
[    4.673960] EDAC MC:  0:  1024MB 1:  1024MB
[    4.673962] EDAC MC:  2:     0MB 3:     0MB
[    4.673963] EDAC MC:  4:     0MB 5:     0MB
[    4.673965] EDAC MC:  6:     0MB 7:     0MB
[    4.674085] EDAC MC0: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:18.2
[    4.683095] EDAC MC: Rev F or later detected
[    4.683104] EDAC amd64: amd64_read_mc_registers: error reading F2x190.
[    4.691267] EDAC amd64: amd64_read_mc_registers: error reading F2x194.
[    4.699408] EDAC MC: DCT0 chip selects:
[    4.699410] EDAC MC:  0:  1024MB 1:  1024MB
[    4.699412] EDAC MC:  2:     0MB 3:     0MB
[    4.699413] EDAC MC:  4:     0MB 5:     0MB
[    4.699415] EDAC MC:  6:     0MB 7:     0MB
[    4.699548] EDAC MC1: Giving out device to 'amd64_edac' 'RevF': DEV
0000:00:19.2
[    4.708683] EDAC PCI0: Giving out device to module 'amd64_edac'
controller 'EDAC PCI
 controller': DEV '0000:00:18.2' (POLLED)

Thanks!

Torsten

> ---
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Mon, 21 Dec 2009 14:52:53 +0100
> Subject: [PATCH] amd64_edac: fix K8 chip select reporting
>
> Fix the case when amd64_debug_display_dimm_sizes() reports only half the
> amount of DRAM on it because it doesn't account for when the single DCT
> operates in 128-bit mode and merges chip selects from different DIMMs.
>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/amd64_edac.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index df5b684..784cc5a 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1700,11 +1700,14 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
>  */
>  static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
>  {
> -       int dimm, size0, size1;
> +       int dimm, size0, size1, factor = 0;
>        u32 dbam;
>        u32 *dcsb;
>
>        if (boot_cpu_data.x86 == 0xf) {
> +               if (pvt->dclr0 & F10_WIDTH_128)
> +                       factor = 1;
> +
>                /* K8 families < revF not supported yet */
>               if (pvt->ext_model < K8_REV_F)
>                        return;
> @@ -1732,7 +1735,8 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
>                        size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
>
>                edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
> -                           dimm * 2, size0, dimm * 2 + 1, size1);
> +                           dimm * 2,     size0 << factor,
> +                           dimm * 2 + 1, size1 << factor);
>        }
>  }
>
> --
> 1.6.5.4
>
>
> --
> Regards/Gruss,
> Boris.
>
> Operating | Advanced Micro Devices GmbH
>  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
>  Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
>  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>  (OSRC)  | Registergericht München, HRB Nr. 43632
>
>
