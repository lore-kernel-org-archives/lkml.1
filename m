Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142Ab0AER4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0AER4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036Ab0AER4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:56:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42698 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab0AER4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:56:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aGSlu99PMapVv+MCmyjzpllfbHg702gjwcCylVSBlB+Xg/wEMOHm37DwLCuT0pshls
         d4r2ef/cO78mWT2WXicl6pEsXAPM7DXW3m84ycLWr/rVjphXw5FgOvlSXsKSu5w03uoI
         Lq4ely52jc7QbJK7PT64t3Q+Llarc3djmhTDc=
MIME-Version: 1.0
Date: Tue, 5 Jan 2010 17:56:15 +0000
Message-ID: <f6be8a431001050956v481017e9i119bca6db20ba1be@mail.gmail.com>
Subject: ata error EH in SWNCQ mode, with nVidia MCP55 sata controller and 
	SAMSUNG HD103UJ
From: Marco Bisetto <marco.bisetto@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A problem with a "IDE interface: nVidia Corporation MCP55 SATA Controller
(rev a3)" and two SAMSUNG HD103UJ sata hard disk drives. Disabling write
cache on a disk gives error:

kernel: [   45.584445] ata1: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
kernel: [   45.584445] ata1: SWNCQ:qc_active 0x1 defer_bits 0x0
last_issue_tag 0x0
kernel: [   45.584445]   dhfis 0x1 dmafis 0x1 sdbfis 0x0
kernel: [   45.584445] ata1: ATA_REG 0x40 ERR_REG 0x0
kernel: [   45.584445] ata1: tag : dhfis dmafis sdbfis sacitve
kernel: [   45.584445] ata1: tag 0x0: 1 1 0 1
kernel: [   45.584445] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0
action 0x6 frozen
kernel: [   45.584445] ata1.00: cmd
61/08:00:3f:f4:e8/00:00:02:00:00/40 tag 0 ncq 4096 out
kernel: [   45.584445]          res
40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
kernel: [   45.584445] ata1.00: status: { DRDY }
kernel: [   45.584445] ata1: hard resetting link

The error appears four times for each disk at startup, only when a disk has
write cache disabled. For example, disabling write cache in two disks:

 45.595788] ata1: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
 45.595800] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
 76.491877] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
 76.511331] ata1: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
107.391075] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
107.423701] ata1: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
138.287465] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
138.332093] ata1: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1

Disabling write cache on disk attached to ata4 and enabling it on disk
attached to ata1:

 45.583489] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
 76.479940] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
107.375643] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1
138.272023] ata4: EH in SWNCQ mode,QC:qc_active 0x1 sactive 0x1

Enabling write cache on both disks = no errors.

I don't think the problem can be associated with bad cables or power
supply, as it happens in each channel, it is the same for each disk and
happens at the same time.

Anybody has ideas on what can it be and if there is a solution?

Thanks.

Marco
