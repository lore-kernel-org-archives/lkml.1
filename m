Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYHBWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYHBWCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYHBWBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:01:50 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:9686 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYHBWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=miWYnqg2ciBW1RA18ypQRozS7swPLKF1ZFyctaLvj+zKDRE+FaLJ1zS78BhSf6EfJi
         bWX/zb/UzcO7+VkQLlLxVgdC4aqKJjiwKERc45Z3YkbcPmzTKq3kCI01QconhGStsAKl
         i8Va9PKv2yp1j+7MejwBI9GppY7MlRjcSCZkM=
Message-ID: <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
Date: Sat, 2 Aug 2008 17:01:46 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "John Stoffel" <john@stoffel.org>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18580.48861.657366.629904@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <200808012319.05038.alistair@devzero.co.uk>
	 <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	 <18580.48861.657366.629904@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/2 John Stoffel <john@stoffel.org>:
>>>>>> "Linas" == Linas Vepstas <linasvepstas@gmail.com> writes:
>
> Linas> 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
>>> On Friday 01 August 2008 18:30:34 Linas Vepstas wrote:
>>>> Hi,
>>>>
>>>> I'm seeing strong, easily reproducible (and silent) corruption on a
>>>> sata-attached
>>>> disk drive on an amd64 board.  It might be the disk itself, but I
>>>> doubt it; googling
>>>> suggests that its somehow iommu-related but I cannot confirm this.
>
> Can you post the output of dmesg after a boot, so we can see which
> driver is being used?  I assume the new Libata stuff, but maybe you
> can also turn on debugging in there as well.  Stuff like SCSI_DEBUG
> (in the SCSI menus) might show us more details here.
>
> Also, have you tried a new SATA cable by any chance?  That's obviously
> the cheaper path than getting a new disk...

I took the problematic hard drive (and its cable) to another computer
with sata ports on it,  and ran my file-copy/compare/fsck tests there,
and saw no problems; so the drive itself and its cable get a clean bill
of health.

Then, rather stupidly, I flashed the latest BIOS for the motherboard
and now have a dead motherboard (it hangs on its way through BIOS,
well before the bootloader.)  So I'm off to buy a new mobo today.

I'll send the dmesg from the older boots later today, if all goes well.
I'm pretty sure I had the new libata on, and the old off -- but its
possible that the .config somehow managed to pull in parts of the
old libata code anyway. I say this because, besides the SATA, the
blown motherboard had an IDE connector in use, and I also had
another PCI IDE card plugged in and in use. I'm imagining that
perhaps the PCI IDE .config might have pulled in old code, maybe
via header file, and thus mangled some lock that the sata side
was using. Just a wild guess.  -- Most people on this mobo hadn't
seen problems, and unlike most people, I had the PCI IDE card
in it.

--linas
