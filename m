Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYJ1BbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYJ1BbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYJ1Ba4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:30:56 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45928 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYJ1Ba4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:30:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=T5tTEIBlI0gNRKZUerEA:9 a=fezsDhuPEPdoI5ZDpYwA:7 a=M7v6c7U4bz7mbDi9LnLAr5zC5ToA:4 a=ef_bbLI2zPQA:10 a=JKVO69kjPAcA:10
Message-ID: <49066B4D.8050109@shaw.ca>
Date: Mon, 27 Oct 2008 19:30:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.3, ata_piix: cannot play audio CD, "disk change detected"
References: <fa.tiFnp4ilM9dVHkjmbJfon9+fKdc@ifi.uio.no>
In-Reply-To: <fa.tiFnp4ilM9dVHkjmbJfon9+fKdc@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi folks,
> 
> If I insert an audio CD in my sata drive to play it via grip, then
> it fails. Grip does not even show the list of audio tracks, nor does
> it play the CD. Instead there is a kernel message saying
> 
> [ 6730.836999] sr0: CDROM not ready yet.
> [ 6732.838572] sr0: disc change detected.
> [ 6783.659021] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [ 6783.659034] ata4.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [ 6783.659035]          cdb 1b 00 00 00 02 00 00 00  00 00 00 00 00 00 00 00
> [ 6783.659036]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> [ 6783.659038] ata4.00: status: { DRDY }
> [ 6783.659046] ata4: hard resetting link
> [ 6784.115039] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 6785.622185] ata4.00: configured for UDMA/100
> [ 6785.622193] ata4: EH complete
> 
> 
> The same CDs work fine with an USB CD drive attached to the same
> PC, so this might be a sata driver issue. (BTW, stopping hal doesn't
> make a difference. Data CDs work fine.)
> 
> Any idea what goes wrong here? Does grip violate the SCSI protocol
> here?  Is there something I could try to help to track this down?

Well, it looks like it was a START STOP UNIT command with the eject bit 
set that timed out. Was something trying to eject the disc?
