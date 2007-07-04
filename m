Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXGDHIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXGDHIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXGDHIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:08:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:50390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbXGDHIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:08:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Tejun Heo <htejun@gmail.com>
Subject: Re: sata_sil, writing bug with multiple cards?
Date: Wed, 4 Jul 2007 09:08:21 +0200
User-Agent: KMail/1.9.6
Cc: 7091@blargh.com, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <courier.4689EFD9.0000589A@blargh.com> <courier.468B17B1.00001A78@blargh.com> <468B19BA.6030202@gmail.com>
In-Reply-To: <468B19BA.6030202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707040908.21512.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2007 05:53:30 Tejun Heo wrote:
> 7091@blargh.com wrote:
> > Apologies for the chain-replying to myself, just replying as I think of
> > things to try.
> > 7091@blargh.com writes:
> >> Here's an odd data point. 
> >> I just broke that array, formatted all three of those partitions
> >> seperately, mounted and did my ISO copy test. 
> >> All three drives, run one at a time, function fine.  No corruption.
> > 
> > Here's another odd one.  I did the following:
> > # Mount all 3 drives as individuals...
> > mount /dev/sda1 /mnt/a
> > mount /dev/sdb1 /mnt/b
> > mount /dev/sdc1 /mnt/c
> > # Copy the same file to all three drives at the same time
> > cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso a/kn10.iso &
> > cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso b/kn10.iso &
> > cp KNOPPIX_V5.1.0CD-2006-12-30-EN.iso c/kn10.iso &
> > Got massive corruption.
> 
> Hmmm... I don't think this is sata_sil driver bug.  cc'ing Andi Kleen
> and lkml.  Andi, the original thread can be read from
> 
> http://thread.gmane.org/gmane.linux.ide/20213

It seems to be a 32bit system. There is no IOMMU. 

If it has >2GB or so it might be worth trying booting it with mem=2G
and see if it goes away. However if it was the standard VIA DAC issue
you should get problems even with a single interface, so probably
that's not it either.

Most likely it is some sort of hardware bug that we might
not be able to do much about. Have you tried contacting SIL or VIA? 
e.g. if you have some other system with a different chipset it might
be useful to test the SIL controllers in those.

I would perhaps also try a newer kernel.

-Andi
