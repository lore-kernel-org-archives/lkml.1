Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbXDHP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbXDHP5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXDHP5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:57:38 -0400
Received: from nn7.de ([85.214.94.156]:47683 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbXDHP5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:57:36 -0400
Subject: Re: Linux 2.6.21-rc6 - regressions update
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <1175899460.5393.9.camel@localhost>
	 <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Apr 2007 17:57:20 +0200
Message-Id: <1176047840.9587.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 16:04 -0700, Linus Torvalds wrote:

[HPET issues resolved]
> > 3) Subject    : SATA breakage on resume
> > References : http://lkml.org/lkml/2007/3/7/233
> > Submitter  : Thomas Gleixner <tglx@linutronix.de>
> >              Soeren Sonnenburg <kernel@nn7.de>
> > Status     : unknown
> > 
> > I am still seeing these messages after a suspend/resume cycle (though
> > all devices work even after multiple suspend/resume cycles)
> > 
> > ATA: abnormal status 0x80 on port 0x000140df
> 
> This seems to be normal, and related to some unknown timing issue. If the 
> thing works for you apart from the message, I'd just ignore it..

Argh! Now after intensive use over the last 2 days, I realized that the
internal harddisk works OK, but the dvd-drive did not after the 7th
suspend/resume cycle - the device was suddenly gone (I could not even
eject the disc I just inserted), more verbose dmesg follows:

ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ata1.00: qc timeout (cmd 0xa1)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ATA: abnormal status 0x80 on port 0x000101f7
ata1.00: qc timeout (cmd 0xa1)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1.00: limiting speed to UDMA/33:PIO3
ata1: failed to recover some devices, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ATA: abnormal status 0x80 on port 0x000101f7
sage repeated 4 times
ata1.00: qc timeout (cmd 0xa1)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1.00: disabled

Soeren
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
