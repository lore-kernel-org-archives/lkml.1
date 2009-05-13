Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZEMC1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZEMC1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZEMC1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:27:24 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:38560 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZEMC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:27:23 -0400
Date: Tue, 12 May 2009 19:27:23 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Message-ID: <20090513022723.GU21505@hexapodia.org>
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org> <49F00EBB.7040504@gmail.com> <20090423070713.GF19113@hexapodia.org> <20090512215256.GA22095@hexapodia.org> <4A0A050D.4000804@gmail.com> <20090513010056.GT21505@hexapodia.org> <51f3faa70905121808x29c12a35n6905104f45883f17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa70905121808x29c12a35n6905104f45883f17@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 07:08:54PM -0600, Robert Hancock wrote:
> On Tue, May 12, 2009 at 7:00 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> > Perhaps, I haven't tracked down exactly what the difference in behavior
> > between working 2.6.29 and broken 2.6.30-rc2 is. ?It seems like the disk
> > spins up more often (in response to hal background probes presumably)
> > with 30-rc2 than it did before, and running "udevadm monitor" I do see
> > the following repeated "change" events happening, even on an idle
> > system:
> >
> > KERNEL[1242175547.793029] change ? /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
> > KERNEL[1242175547.794669] change ? /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
[snip]
> Those events seem rather suspicious. Hmm:
> 
> [    2.770959] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-U633A, D200, max
> UDMA/100, ATAPI AN
> 
> Did libata report it was using ATAPI AN in 2.6.29?

Yes, AN is present in every log I have for that device (back to
2.6.28.1).

> You could try bisecting to see if you can find which patch started
> triggering those spurious events..

Heh, I was dreading a bisect where each step burned a coaster, but just
looking for events is easy.  I'll try that tomorrow.

-andy
