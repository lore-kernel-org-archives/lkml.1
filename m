Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbXJVJsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbXJVJsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJVJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:48:13 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:33639 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXJVJsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:48:12 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: sata sil3114 vs. certain seagate drives results in filesystem corruptions
Date: Mon, 22 Oct 2007 11:48:08 +0200
User-Agent: KMail/1.9.6
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <1192863324.5720.162.camel@localhost> <471C071C.2010202@gmail.com>
In-Reply-To: <471C071C.2010202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221148.08809.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday 22 October 2007 04:12:44 Tejun Heo wrote:
> Helo,
>
> Soeren Sonnenburg wrote:
> > I finally managed to find a *reproducible* setup and way to trigger
> > random corruptions using a sata sil 3114 controller connected to 4
> > seagate drives
> >
> > port 1: ST3400832AS sda
> > port 2: ST3400620AS sdb
> > port 3: ST3750640AS sdc
> > port 4: ST3750640AS sdd
> >
> > sda & sdb form md0 via a raid1 setup followed by an additional
> > devicemapper layer ( root ). sdc and sdb are separate and also have an
> > additional device mapper layer ( public ) and ( backups ).
> >
> > Now when I write large files of zeros to root(sda&sdb) and read the file
> > back in it contains a few nonzero entries:
> >
> > # dd if=/dev/zero of=/foo bs=1M count=2000
> > # hexdump /foo
> > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> > *
> > <after >1GB random parts, within large blocks of zeroes>
> >
> > I can reliably trigger this on the md0 / devmapper-root setup when I
> > write about 2GB of data (note that this machine has 1.5G of memory - and
> > still 1GB is often enough to see this problem). Here it does not matter
> > where in the filesystem I do these writes.

Thats almost the same test as I'm always doing. Only I do not write only 2GB, 
but as much as it fits onto the disk. On reading back this file, the 
filesystem will report errors somewhere between 50GB and 230GB (disk size is 
250GB).

>
> Thanks.  I'll try to reproduce the problem here.  What's your motherboard?

All tested S2882 boards here.


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
