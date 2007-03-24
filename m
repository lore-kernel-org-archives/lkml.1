Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXCXJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXCXJRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXCXJRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 05:17:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:38513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406AbXCXJRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 05:17:36 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-ia64@vger.kernel.org
Subject: sata-vsc broken on SGI Prism
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
X-Yow: Mary Tyler Moore's SEVENTH HUSBAND is wearing my DACRON TANK TOP
 in a cheap hotel in HONOLULU!
Date: Sat, 24 Mar 2007 10:17:24 +0100
Message-ID: <je8xdnova3.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this panic when loading sata-vsc on a SGI Prism:

Loading sata_vsc
ACPI: Unable to derive IRQ for device 0001:00:03.0
ACPI: PCI Interrupt 0001:00:03.0[A]: no GSI
FRZ XN request short error. 
FRZ XN error detail 1A:
	Command word: 0x11
	Supplemental: 0xff
	Source node id: 0x0
	Source chip id: 0x2
	Destination chip id: 0x0
	Data error: 0x0
	Echo: 0x70
	Valid: 0x0
	Address: 0x1802000021
FRZ XN error detail 1B:
	Command word: 0x0
	Supplemental: 0x0
	Source node id: 0x0
	Source chip id: 0x0
	Destination chip id: 0x0
	Echo: 0x0
	Valid: 0x0
	Address: 0x0
Fatal ICE HW error
Kernel panic - not syncing: hub_eint_handler: Fatal TIO Error

Bisection has identified this patch (together with the follow-up patch to
fix the compilation failure):

commit 7cbaa86b937b0b1fab95c159989f6a3c00bbcf78
Author: Dan Wolstenholme <daniel@wolstenholme.net>
Date:   Tue Jan 9 05:59:21 2007 -0500

    [libata] sata_vsc: support PCI MSI
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
