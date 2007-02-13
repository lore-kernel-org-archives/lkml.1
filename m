Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXBMLaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXBMLaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXBMLaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:30:23 -0500
Received: from sullivan.realtime.net ([205.238.132.226]:2054 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXBMLaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:30:23 -0500
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 06:30:22 EST
Date: Tue, 13 Feb 2007 04:57:52 -0600 (CST)
Message-Id: <200702131057.l1DAvqaw012898@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20: Rebuild after trivial patch rebuilds way too much
In-Reply-To: <200702122037.45927.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 12:38:15 -0500 (EST), Andrey Borzenkov wrote:
> Is not it too much fore a trivial two lines patch to a single file?
> 
> {pts/1}% stg import
> ~/patch/Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch
> Importing
> patch "Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch"... done
> Now at patch "Re_2_6_20_rc6_libata_PATA_ATAPI_CDROM_is_not_working.patch"
> {pts/1}% make -C ~/src/linux-git O=$HOME/build/linux-2.6.20
> make: Entering directory `/home/bor/src/linux-git'
.. 120 lines of make ...


You can ask Kbuild why its building with make V=2.

make V=2 -C ~/src/linux-git O=$HOME/build/linux-2.6.20

from scripts/Kbuild.include:
###
# why - tell why a a target got build
#       enabled by make V=2
#       Output (listed in the order they are checked):
#          (1) - due to target is PHONY
#          (2) - due to target missing
#          (3) - due to: file1.h file2.h
#          (4) - due to command line change
#          (5) - due to missing .cmd file
#          (6) - due to target not in $(targets)
# (1) PHONY targets are always build
# (2) No target, so we better build it
# (3) Prerequisite is newer than target
# (4) The command line stored in the file named dir/.target.cmd
#     differed from actual command line. This happens when compiler
#     options changes
# (5) No dir/.target.cmd file (used to store command line)
# (6) No dir/.target.cmd file and target not listed in $(targets)
#     This is a good hint that there is a bug in the kbuild file


Regards,
milton
