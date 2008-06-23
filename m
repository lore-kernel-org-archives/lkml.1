Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYFWTFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYFWTFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYFWTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:05:08 -0400
Received: from main.gmane.org ([80.91.229.2]:57263 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYFWTFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:05:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jeroen Beerstra <jb@scorpion77.cjb.net>
Subject: non functional pata dvd drive under 2.6.25.6
Date: Mon, 23 Jun 2008 21:02:23 +0200
Message-ID: <vi85j5-uig.ln1@scorpion77.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dhcp-077-248-068-247.chello.nl
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi there,

I've filed this as a bug with redhat bugzilla (12-6), https://
bugzilla.redhat.com/show_bug.cgi?id=451081, but so far I've had no 
response at all ... so here we go ;)

Basicly my ide dvd writer is non functional with Fedora 9 (kernel 
2.6.25.6). So far I've seen it functional only once when I booted with 
media already inserted, but for the rest it's pretty much like this:

excerpt from dmesg

ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata10.00: status: { DRDY }
ata10: soft resetting link
ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
ACPI=0x1f01f (30:600:0x13)
ata10.00: configured for PIO0
ata10: EH complete
ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata10.00: status: { DRDY }
ata10: soft resetting link
ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
ACPI=0x1f01f (30:600:0x13)
ata10.00: configured for PIO0
ata10: EH complete
sr 10:0:0:0: ioctl_internal_command return code = 8000002
   : Sense Key : Aborted Command [current] [descriptor]
   : Add. Sense: No additional sense information
ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata10.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata10.00: status: { DRDY }
ata10: soft resetting link
ata10: nv_mode_filter: 0x1&0x1f01f->0x1, BIOS=0x1f000 (0xc5000000) 
ACPI=0x1f01f (30:600:0x13)
ata10.00: configured for PIO0
ata10: EH complete

cat /sys/bus/scsi/devices/10:0:0:0/model 
PATA 20X20X12X 

The drive is completely non functional.

System is a Nforce 780i SLI MB (Asus P5N-T Deluxe) with an Q9450 INtel 
Core2 Quad CPU and 4 GB of ram.

With Windows XP/Vista there are no problems with this drive and also I 
had no problems installing Fedora from this drive in the first place, so 
I doubt if it is a hardware problem. 

I can live with the fact that I only have one writer available but not 
with the fact that everything that tries to access the drive hangs with 
status D for a very long time, hald-addon-storage for one....

-- 
jb

