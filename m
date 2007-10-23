Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbXJWHA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbXJWHA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXJWHAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:00:47 -0400
Received: from nn7.de ([85.214.94.156]:52744 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXJWHAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:00:46 -0400
Subject: Re: sata sil3114 vs. certain seagate drives results in filesystem
	corruptions
From: Soeren Sonnenburg <kernel@nn7.de>
To: Bernd Schubert <bs@q-leap.de>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200710221259.27989.bs@q-leap.de>
References: <1192863324.5720.162.camel@localhost>
	 <200710221148.08809.bs@q-leap.de> <1193049392.10246.29.camel@localhost>
	 <200710221259.27989.bs@q-leap.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Oct 2007 08:57:45 +0200
Message-Id: <1193122665.4384.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 12:59 +0200, Bernd Schubert wrote: 
> On Monday 22 October 2007 12:36:32 Soeren Sonnenburg wrote:
> > On Mon, 2007-10-22 at 11:48 +0200, Bernd Schubert wrote:
> > > Hello,
> > >
> > > On Monday 22 October 2007 04:12:44 Tejun Heo wrote:
> > > > Helo,
> > > > [...]
> > > >
> > > > > Now when I write large files of zeros to root(sda&sdb) and read the
> > > > > file back in it contains a few nonzero entries:
> > > > >
> > > > > # dd if=/dev/zero of=/foo bs=1M count=2000
> > > > > # hexdump /foo
> > > > > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> > > > > *
> > > > > <after >1GB random parts, within large blocks of zeroes>
> > > > >
> > > > > I can reliably trigger this on the md0 / devmapper-root setup when I
> > > > > write about 2GB of data (note that this machine has 1.5G of memory -
> > > > > and still 1GB is often enough to see this problem). Here it does not
> > > > > matter where in the filesystem I do these writes.
> > >
> > > Thats almost the same test as I'm always doing. Only I do not write only
> > > 2GB,
> >
> > Well when I read your mail I thought that I could be seeing exactly the
> > same bug... it still may be. However ``my'' problem does not go away
> > with the mod15fix ...
> 
> Yeah, pity it did not fix it :( I will try to port Tejuns patch 
> (http://home-tj.org/wiki/index.php/Sil_m15w#Patches) to 2.6.23 today or 
> tomorrow. If you are testing anyway, could you then also try this?

Hmmhh, dmesg said the m15 fix was turned on (at least it appeared for
the 2 drives in question in dmesg), so I fear it is something different.
On the other hand this is a 'production' machine so I am not too eager
to try very experimental things...

> > > but as much as it fits onto the disk. On reading back this file, the
> > > filesystem will report errors somewhere between 50GB and 230GB (disk size
> > > is 250GB).
> >
> > Wow, I really see lots of corruptions (well every 1-2 GB a couple of
> > bytes are corrupted). Are you getting similiarly many in the 50G - 230G
> > region?
> >
> > > > Thanks.  I'll try to reproduce the problem here.  What's your
> > > > motherboard?
> > >
> > > All tested S2882 boards here.
> >
> > I assume all equipped with lots of memory and mostly empty pci slots?
> 
> Yes, all pci-slots are free and the systems to have between 4 and 16GB memory 
> (ecc, monitored with edac). Well, those are cluster systems (actually tyan 
> names those B2882).
> Do you think the configuration is related? Here it also happens with odirect, 
> we tested this to minimize memory effects.

Mine is just a a7v8x with via KT400 chipset... really old, but several
of the pci slots are filled, so the problem may be more likely to happen
it may happen here... on the other hand I never tried writing 50-250G on
the drives I considered OK. Will do. Also what could be helpful is that
we both see patterns in the corruptions, like corruptions are always 512
bytes long or so (IIRC in my case they were only up to 64 bytes).

Soeren
