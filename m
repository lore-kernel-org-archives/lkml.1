Return-Path: <linux-kernel-owner+w=401wt.eu-S965569AbXCLNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569AbXCLNZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXCLNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:25:49 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:37081 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965569AbXCLNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:25:48 -0400
Date: Mon, 12 Mar 2007 14:25:46 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Message-ID: <20070312132546.GC12265@janus>
References: <20070312085447.GA10955@janus> <20070312112414.GA12265@janus> <200703121207.19042.s0348365@sms.ed.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703121207.19042.s0348365@sms.ed.ac.uk>
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:07:18PM +0000, Alistair John Strachan wrote:
> On Monday 12 March 2007 11:24, Frank van Maarseveen wrote:
> > On Mon, Mar 12, 2007 at 09:54:47AM +0100, Frank van Maarseveen wrote:
> > > 2.6.19 is ok, 2.6.20.[12] hangs from the moment DMA is turned on (hdparm
> > > -d 1 /dev/hda):
> > >
> > > 	hda: dma_timer_expiry: dma status == 0x20
> > > 	hda: DMA timeout retry
> > > 	hda: timeout waiting for DMA
> > > 	hda: status error: status=0x58 {
> > > 	DriveReady
> > > 	SeekComplete
> > > 	DataRequest
> > > 	}
> [snip]
> > This system has SATA but there's only one PATA disk
> 
> Not a solution, unfortunately, but try disabling CONFIG_IDE and using Alan's 
> new PATA drivers. For your Intel systems, this should mean you need only:
> 
> CONFIG_ATA_PIIX
> 
> For both SATA and PATA support. You'll need the appropriate SCSI modules built 
> in (if you say =y), i.e. SCSI disk and SCSI CDROM should be built in.

yes, that worked... after booting with root=/dev/sda2 and s/hda/sda/
/etc/fstab /etc/lilo.conf + lilo. didn't mount a /dev/sr0 for a loong
time.

So, are /dev/hd* going to disappear in a few years? iow, does it make
sense to _slowly_ start to migrate to /dev/sd*?

The problem is there's no plan B in case of any troubles except rename
everything back again to boot an old kernel.

-- 
Frank
