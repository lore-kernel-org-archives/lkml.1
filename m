Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXAVVDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXAVVDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXAVVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:03:21 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55354 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932664AbXAVVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:03:20 -0500
X-Sasl-enc: fq3nAOyoDiTJ973RHnYzpv3Z7xGvHlEKQK5afU2w5/X3 1169499798
Date: Mon, 22 Jan 2007 19:03:12 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
Message-ID: <20070122210312.GD4516@khazad-dum.debian.net>
References: <1168588629.5403.7.camel@localhost> <45A7BFB0.9090308@garzik.org> <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169456682.2901.18.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007, Soeren Sonnenburg wrote:
> - For SIL3114 and SIL3124 you don't have to run any commands at all. It
> should notice when you yank the cable, or plug in a new device. All you
> have to do is to stop using the devices before unplugging, e.g. unmount
> partitions on the disk or remove the disk from a dm setup). One can
> validate which disks are attached using ``scsiadd -p''. Note that the
> device name may change from e.g. /dev/sdd to /dev/sde on a
> remove/reinsert cycle (this can be fixed by using udev-provided
> persistent names). Also note that it is perfectly normal to see messages
> like this in dmesg:

Does SATA electrical conector keying let the disk firmware unload heads
before the user manages to pull it out enough to sever power?  If it does
not, the drive will do an emergency head unload, which is not good and will
likely reduce the drive's lifetime.

Using hdparm -Y before the unplug, or scsiadd -r (on a kernel that has
Tejun's new patch to optionally issue an START_STOP_UNIT to the SCSI device
enabled) is probably a good idea.  Unless it is a shared SATA port (I don't
know if such a thing exists yet) and another box is talking to the disk,
etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
