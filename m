Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYHVRZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYHVRZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHVRYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:24:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:61591 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYHVRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fMAB9cB5wrjOoya3SJFuCmvMtKYvFP/qCasIiFZ28vOQk2mutqMXG92oAeN8r0MbyL
         67ImHaV3EVwqfNhmauOdk+H2fBFse9zRaRycb5bdvXGZTkDWL8xOAxdd7rhBJ/dG1zlG
         pPdcCkVMqRVONFuiz4CspnCYz0/Kflgj30X7Q=
Message-ID: <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
Date: Fri, 22 Aug 2008 10:24:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
Cc: "Alexander Huemer" <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48AE90BB.5090800@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at>
	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>
	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>
	 <489B85A3.7030500@sbg.ac.at>
	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
	 <48A43CB5.8010709@sbg.ac.at>
	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>
	 <48AD8125.7050104@sbg.ac.at>
	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
	 <48AE90BB.5090800@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 3:11 AM, Helge Hafting
<helge.hafting@aitel.hist.no> wrote:
> I also see mtrr problems. I use 2.6.27-rc4, with this in my .config:
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> (Have no idea what the last one is about, the docs didn't say.)
>
> Everything is fine during boot, I see this in dmesg:
> Found optimal setting for mtrr clean up
> gran_size: 1M   chunk_size: 64M         num_reg: 7      lose RAM: 0M
> range0: 0000000000000000 - 000000007c000000
> Setting variable MTRR 0, base: 0MB, range: 1024MB, type WB
> Setting variable MTRR 1, base: 1024MB, range: 512MB, type WB
> Setting variable MTRR 2, base: 1536MB, range: 256MB, type WB
> Setting variable MTRR 3, base: 1792MB, range: 128MB, type WB
> Setting variable MTRR 4, base: 1920MB, range: 64MB, type WB
> range: 000000007c000000 - 0000000080000000
> Setting variable MTRR 5, base: 1984MB, range: 64MB, type WB
> hole: 000000007ff00000 - 0000000080000000
> Setting variable MTRR 6, base: 2047MB, range: 1MB, type UC
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> After WB checking
> MTRR MAP PFN: 0000000000000000 - 0000000000080000
> After UC checking
> MTRR MAP PFN: 0000000000000000 - 000000000007ff00
> After sorting
> MTRR MAP PFN: 0000000000000000 - 000000000007ff00
>
> X gets problems however, from my Xorg.0.log:(II) VESA(0): initializing int10
> (II) VESA(0): Primary V_BIOS segment is: 0xc000
> (II) VESA(0): VESA BIOS detected
> (II) VESA(0): VESA VBE Version 3.0
> (II) VESA(0): VESA VBE Total Mem: 14336 kB
> (II) VESA(0): VESA VBE OEM: NVIDIA
> (II) VESA(0): VESA VBE OEM Software Rev: 96.134
> (II) VESA(0): VESA VBE OEM Vendor: NVIDIA Corporation
> (II) VESA(0): VESA VBE OEM Product: G86 Board - dawson0
> (II) VESA(0): VESA VBE OEM Product Rev: Chip Rev
> (II) VESA(0): Splitting WC range: base: 0xfb000000, size: 0xe00000
> (II) VESA(0): Splitting WC range: base: 0xfb800000, size: 0x600000
> (==) VESA(0): Write-combining range (0xfbc00000,0x200000)
> (WW) VESA(0): Failed to set up write-combining range (0xfb800000,0x600000)
> (WW) VESA(0): Failed to set up write-combining range (0xfb000000,0xe00000)
> (II) VESA(0): virtual address = 0x7f17bd6dd000,
>        physical address = 0xfb000000, size = 14680064
>
> And dmesg says:
> mtrr: no more MTRRs available
> mtrr: no more MTRRs available
>
> So I get one write-combining range where X wants three.
> $ cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
> reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
> reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
> reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> reg07: base=0xfbc00000 (4028MB), size=   2MB: write-combining, count=1
>
> 2MB does obviously not cover the entire framebuffer. :-(
>
please boot with "mtrr_spare_reg_nr=3 debug"

YH
