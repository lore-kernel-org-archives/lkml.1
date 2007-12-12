Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXLLPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXLLPKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLLPKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:10:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:46478 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXLLPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:sender;
        b=jXLcAwVwpGrv/oGgLzKHcxCzhCqdtuK+/G0DoIaYWss+ecEegedmV5bb6dbxlIEWC18jE/475/XLkzFmfzn86naEi7XzbB/126Le0S4iX3e74HNBajZpbk253tJdpAgM9HlEBRbdX/93ihLHjTvP1/9qgC9sDpYVA5kcutJTJHk=
Date: Wed, 12 Dec 2007 16:10:25 +0100
From: Friedrich =?iso-8859-1?Q?G=F6pel?= <shado23@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Subject: ATAPI/pata_amd regression
Message-ID: <20071212151025.GA21445@moesenspecht.in.y0ur.4ss>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing 2.6.24-rc5 I noticed my Plextor DVD writer locking up as
soon I start k3b (KDE CD burning app) with the following:

 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
 ata5.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 8 in
          cdb ac 00 00 00 00 00 00 00  00 01 03 00 00 00 00 00
          res 58/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
 ata5.00: status: { DRDY DRQ }
 ata5: soft resetting link
 ata5.00: qc timeout (cmd 0xa1)
 ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata5.00: revalidation failed (errno=-5)
 ata5: failed to recover some devices, retrying in 5 secs
 ata5: port is slow to respond, please be patient (Status 0x80)
 ata5: device not ready (errno=-16), forcing hardreset
 ata5: soft resetting link
 ata5.00: qc timeout (cmd 0xa1)
 ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata5.00: revalidation failed (errno=-5)
 ata5: failed to recover some devices, retrying in 5 secs
 ata5: port is slow to respond, please be patient (Status 0x80)
 ata5: device not ready (errno=-16), forcing hardreset
 ata5: soft resetting link
 ata5.00: qc timeout (cmd 0xa1)
 ata5.00: failed to IDENTIFY (I/O error, err_mask=0x4)
 ata5.00: revalidation failed (errno=-5)
 ata5.00: disabled
 ata5: port is slow to respond, please be patient (Status 0x80)
 ata5: device not ready (errno=-16), forcing hardreset
 ata5: soft resetting link
 ata5: EH complete


Whereas doing the same on .23 just yields:

 ata5.00: 16 bytes trailing data
 ata5.00: 16 bytes trailing data
 ata5.00: 16 bytes trailing data
 ata5.00: 16 bytes trailing data


On .24 the drive is completely irresponsive afterwards, until I reboot.
Burning a DVD from a terminal with growisofs works though, if I don't start k3b.


Cheers,


Friedrich Göpel
