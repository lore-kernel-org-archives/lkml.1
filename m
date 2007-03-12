Return-Path: <linux-kernel-owner+w=401wt.eu-S965750AbXCLMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965750AbXCLMOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965745AbXCLMOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:14:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:40935 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750AbXCLMOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XY3/f8AIpjE5etilWAwjmyh2wRD3Bwn5o8WqvXM34do+DfNjBrQmNVZRpXiVWYVPv0juDXZN8hD4GvtEpDT/aE7BFn74nzpOHORjvKYXLXwyKio27YtaKGGS78uhP+aDvIJZw2lLJHMtZsyN1qrN/tS2w0AUuvcQ6eSJLxpC2VA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: 2.6.20*: PATA DMA timeout, hangs (2)
Date: Mon, 12 Mar 2007 13:21:18 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070312085447.GA10955@janus> <20070312112414.GA12265@janus>
In-Reply-To: <20070312112414.GA12265@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121321.18299.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Could you check if this is the same problem as this one:

http://bugzilla.kernel.org/show_bug.cgi?id=8169

Thanks,
Bart

On Monday 12 March 2007, Frank van Maarseveen wrote:
> On Mon, Mar 12, 2007 at 09:54:47AM +0100, Frank van Maarseveen wrote:
> > 
> > 2.6.19 is ok, 2.6.20.[12] hangs from the moment DMA is turned on (hdparm
> > -d 1 /dev/hda):
> > 
> > 	hda: dma_timer_expiry: dma status == 0x20
> > 	hda: DMA timeout retry
> > 	hda: timeout waiting for DMA
> > 	hda: status error: status=0x58 {
> > 	DriveReady
> > 	SeekComplete
> > 	DataRequest
> > 	}
> 
> I have a totally different PATA based system (P4 HT) with similar symptoms
> except that it seem to recover by switching DMA off during boot after
> 5 errors:
> 
> hda: dma_timer_expiry: dma status == 0x20
> hda: DMA timeout retry
> hda: timeout waiting for DMA
> hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> hda: dma_timer_expiry: dma status == 0x20
> hda: DMA timeout retry
> hda: timeout waiting for DMA
> hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> hda: dma_timer_expiry: dma status == 0x20
> hda: DMA timeout retry
> hda: timeout waiting for DMA
> hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> hda: dma_timer_expiry: dma status == 0x20
> hda: DMA timeout retry
> hda: timeout waiting for DMA
> hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> hda: dma_timer_expiry: dma status == 0x20
> hda: DMA timeout retry
> hda: timeout waiting for DMA
> hda: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hda: drive not ready for command
> 
> So in this case it doesn't hang but is not really usable either.
> 
> lspci:
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> 01:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX 5200] (rev a1)
> 02:00.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet Controller (rev 05)
> 
> This system has SATA but there's only one PATA disk
