Return-Path: <linux-kernel-owner+w=401wt.eu-S1761832AbXEPXsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761832AbXEPXsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbXEPXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:48:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41234
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXEPXsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:48:03 -0400
From: Rob Landley <rob@landley.net>
To: "Francesco Pretto" <ceztko@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Wed, 16 May 2007 19:47:35 -0400
User-Agent: KMail/1.9.1
Cc: "Dave Jones" <davej@redhat.com>, "Tejun Heo" <htejun@gmail.com>,
       "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <200705160129.16048.rob@landley.net> <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com>
In-Reply-To: <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161947.36177.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 5:15 am, Francesco Pretto wrote:
> - everyone else:
> // continue to do nothing :-)
> reboot();

That would be cool, but the impression I got from 
http://linux-ata.org/shutdown.html was that shutdown commands were supposed 
to _add_ quiescing of drives in order to avoid emergency head parking on 
poweroff.

That article says:

> Distros should update their shutdown(8) to do the followings.
> Check whether /sys/modules/libata/parameters/spindown_compat exists. If it
> does, write 0 to it. For each libata harddisk
> Check whether /sys/class/scsi_disk/h:c:i:l/manage_start_stop exists. If it
> doesn't, synchronize cache and spin the disk down as before. If it does, do
> nothing and continue to the next disk. The file is also accessible as
> /sys/block/sdX/device/scsi_disk:*/manage_start_stop.

You're saying all this is to work around kernels _before_ 2.6.22, and instead 
of updating your shutdown you could just either update the kernel instead?

> If exists some, at this point, exotic shutdown(8) implementation that
> is trying to issue STANDBYBOW on libata/scsi devices, it will get a
> fat warning. The warning could also state that the only supported way
> is to leave complete responsibility of spinning down the hard disks to
> kernel, so eventually it could be cleaned of checks and compatibility
> options.

I'm all for leaving this to the kernel.  I play in the embedded space a lot, 
so the less I can get away with doing, the better. :)

Rob
