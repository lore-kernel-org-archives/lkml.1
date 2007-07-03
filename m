Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXGCRpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXGCRpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbXGCRpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:45:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57094 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754913AbXGCRpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:45:07 -0400
Date: Tue, 3 Jul 2007 18:51:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Libata PATA status
Message-ID: <20070703185116.59c8f5f5@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Libata General with respect to PATA
====================================

Wrong port and IRQ reporting - IRQ now fixed by Tejun, port reporting
fixes sent to Andrew. All these are cosmetic and don't harm debug.

Still can't user set drive speed or user issue commands at a given speed.
Needed to allow users to bump cable rules, fix strange stuff and for some
emulated chips to issue RAID control ATA packets in PIO0 (no I've no idea
why they only work in PIO0 ;)).

No serialization of channel pairs.

PATA General
============

Current kernels now support HPA (Host Protected Area) but default to
honouring it. Probably a wrong default for PATA but we need to decide the
right way to expose it nicely.

Cable detection should now be sane. Still issues with SATA bridges. Some
test hacks in my code base but nothing for upstream yet.

My tree has global DMA control aka ide=nodma. Need to decide the best way
to push a version of this.

Ancient non IORDY capable devices need patches still in my devel tree

Post SRST we need to decide what to do about mode setting - do we put the
controller in PIO0 specifically ? My tree does and this seems to help on
non PC systems.

No PATA hotplug support yet. Need warmplug helpers for some chipsets (eg
some intel ICH) to avoid risk of hangs.


Chipsets
========
PIIX
	Tejun should have the MWDMA bugs fixed otherwise so far so good.
	Mostly maintained by other people.
ACPI
	Driver needs a rewrite based upon what has been learned about the
	BIOS handling of the ACPI methods. On the TODO list
ALI
	2.6.22rc7 fixed the last known non-atapi bug. Stil some ATAPI
	problem reports unresolved
AMD
	Solid. ACPI tweaks in my tree for Nvidia cable detect and pushed
	to -mm. Target for 2.6.23
ARTOP
	No reports, but nobody appears to be using one
ATIIXP
	Rock solid. For SATA side use AHCI
CMD640
	Seems to work but still little testing
CMD64X
	Tested on x86, needs more Sparc/Alpha feedback
CS5520
	Solid for PIO. No virtual DMA support (and none likely unless its
	contributed)
CS5530
	Obscure hang bug fix just sent to -mm tree but not observed in
	real world use. Otherwise stable
CS5535
	No reports
CYPRESS
	Needs someone with an ancient Alpha. May drop entirely
EFAR
	Seems solid. Needs some PIIX updates cross checking for EFAR
	relevance. Low priority
GENERIC
	Fix for "DMA set up but not used" bug in -git
HPT366
	Seems to be solid. Needs a backport of the chip detect changes
	Sergei just finished for old IDE. Low priority no real impact from
	their lack
HPT37X
	Working but some further work required to get it behaving on all
	combinations
HPT3X2N
	Still has problems on some systems. Tracking the work being done
	in old-ide which seems to behave similarly
HPT3X3
	Solid PIO support sent to -mm. DMA is problematic. Doesn't work
	with old IDE at all so not too problematic. Doesn't work in
	base kernel
ISAPNP
	Seems to work, no bug reports but not many users
IT8212
	Multiple fixes, should now be stable in RAID and Pass-through
	modes thanks to driver fixes and core fixes from Tejun
IT8213
	No idea
JMICRON
	Works reliably. No recent changes
LEGACY
	Works ok. Complete rewrite in progress to clean up all the
	pre-PCI support
TRIFLEX
	Solid, no recent changes.
MARVELL
	Solid, will be replaced by PATA AHCI-like support in time
	(but not by me)
MPIIX
	Solid, no recent changes
OLDPIIX
	Solid, no recent changes
NETCELL
	Solid, no recent changes
NS87410
	Still experimental, almost no users
OPTIPIO
	Very much experimental but seems to work
OPTIDMA
	Very much experimental, but seems to work. Only one user known
	however
PCMCIA
	Works reliably. Some problems with IRQ routing on some CF cards
	that seem to be card related. Works on systems with no DMA API
	support as of patches sent to -mm
PDC_OLD
	2.6.22-git has cable detection bug fixed
QDI
	Works, will be folded into LEGACY rewrite
RADISYS
	Very experimental, no changes, low priority
RZ1000
	Solid, works, no changes
SC1200
	Single channel only still. Needs work for dual channel
	-mm has fix for a DMA hang bug
SERVERWORKS
	Solid, no changes of note
SIL680
	Solid, no recent changes
SIS
	Current tree fixes crash on boot some users reported, code
	cleanups, no other major changes for pure PATA devices
VIA
	Solid. Sent acpi patch for -mm to try and fix the one remaining
	mystery "how to spot VIA with onboard SATA bridges properly. If
	you've got a VIA board with SATA ports that appear as PATA
	channels please drop me an email as I'd like to get more info
	on what is affected.
WINBOND
	No changes, still experimental
