Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbXA3TxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbXA3TxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXA3TxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:53:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:44616 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXA3TxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:53:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=P4i4LWr8ZgGh5vt/FV+AnGOEYI7pjQ2DG+EpmG+MvPPDn86W3Tl84lf1Ui/a4UGaJiH7An90bvPKURoa2QaZa++I5TXwKZoJpV2J9cQ0vngr3Tz70ICncG4b4GwjFKyXAjo8g2nNYEihKscKY5YYFY9HF/4S+nR7shIHr2xoQmI=
Date: Tue, 30 Jan 2007 20:53:19 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Peter Osterlund <petero2@telia.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.20-rc6] pktcdvd doesn't work
Message-ID: <20070130195319.GA10994@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
is written to the device is lost after umount.
I rarely use pktcdvd but at some point it used to work on my system.

This is what I'm doing:

root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
using device /dev/scd0
1029KB internal buffer
setting write speed to 12x
Settings for /dev/scd0:
        Fixed packets, size 32
        Mode-2 disc

I'm going to do a quick setup of /dev/scd0. The disc is going to be
blanked and formatted with one big track. All data on the device will be
lost!! Press CTRL-C to cancel now.
ENTER to continue.

Initiating quick disc blank
Disc capacity is 275616 blocks (551232KB/538MB)
Formatting track
start=0, blocks=16, type=RESERVED
start=16, blocks=3, type=VRS
start=19, blocks=237, type=USPACE
start=256, blocks=1, type=ANCHOR
start=257, blocks=31, type=USPACE
start=288, blocks=32, type=PVDS
start=320, blocks=32, type=LVID
start=352, blocks=32, type=STABLE
start=384, blocks=1024, type=SSPACE
start=1408, blocks=273920, type=PSPACE
start=275328, blocks=31, type=USPACE
start=275359, blocks=1, type=ANCHOR
start=275360, blocks=160, type=USPACE
start=275520, blocks=32, type=STABLE
start=275552, blocks=32, type=RVDS
start=275584, blocks=31, type=USPACE
start=275615, blocks=1, type=ANCHOR
Writing UDF structures to disc
Quick setup complete!
root@dreamland:/tmp# pktsetup pkt0 /dev/scd0
pktcdvd: writer pktcdvd0 mapped to sr0
root@dreamland:/tmp# mount -t udf -o rw,noatime /dev/pktcdvd/pkt0 /cdrom
pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
pktcdvd: Max. media speed: 4
pktcdvd: write speed 4x
pktcdvd: 0kB available on disc
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 18:18 (103c)
root@dreamland:/tmp# touch /cdrom/test
root@dreamland:/tmp# ll /cdrom
total 0
drwxr-xr-x 2 root root 40 2007-01-30 18:18 lost+found
-rw-r--r-- 1 root root  0 2007-01-30 20:42 test
root@dreamland:/tmp# umount /cdrom
root@dreamland:/tmp# mount -t udf -o rw,noatime /dev/pktcdvd/pkt0 /cdrom
pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
pktcdvd: Max. media speed: 4
pktcdvd: write speed 4x
pktcdvd: 0kB available on disc
UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 18:18 (103c)
root@dreamland:/tmp# ll /cdrom
total 0
drwxr-xr-x 2 root root 40 2007-01-30 18:18 lost+found

As you can see the file is gone. Also notice that pktcdvd says:

pktcdvd: 0kB available on disc

which sounds very strange. The drive is this one:

scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray

The disk:

root@dreamland:/tmp# cdrwtool -d /dev/scd0 -i
using device /dev/scd0
1029KB internal buffer
setting write speed to 12x

DISC INFO:
	erasable : Yes
	border = 3
	Disc status = 2
	number of first track = 1
	number of sessions = 1
	number of tracks = 1
	status of last track = 1
	uru = 0
	did_v = 1
	dbc_v = 0
	disc type = 32
	disc_id = 9773913
	lead_in = 255:255:255 (1166880)
	lead_out = 255:255:255 (1166880)
	OPC entries = 0

TRACK INFO:

Track 1
	track_number = 1
	session_number = 1
	damage = 0
	copy = 0
	track_mode = 7
	Rt = 1
	blank = 0
	packet = 1
	fp = 1
	data_mode = 2
	lra_v = 0
	nwa_v = 0
	track_start = 0
	next_writable = 0
	last_recorded = 0
	free_blocks = 0
	packet_size = 32
	track_size = 275616 (551232KB)

I've tried different media with the same result. Furthermore I can
correctly write an ISO9660 fs on these cdrw disks.


Luca
-- 
Un apostolo vedendo Gesu` camminare sulle acque:
- Cazzo se e` buono 'sto fumo!!!
