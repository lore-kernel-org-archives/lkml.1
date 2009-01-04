Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZADPX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZADPX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZADPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:23:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44027 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZADPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:23:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:23:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 00/11] firewire: cdev: proposed ABI extensions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here come updated implementations (based on Jay Fenlason's patches) or
first implementations of the pending <linux/firewire-cdev.h> ABI
extensions. Still not done though:
  - Add ioctl to deallocate an isochronous context.
  - Allow more than one isochronous context per fd.
  - Document David Moore's OHCI timestamp change,
    increment ABI version number accordingly.

Also, while Jay Fenlason already tested his implementations, I did not
yet do any runtime test at all of any of the new ioctls as implemented
in the following updates.  Nor do I have matching libraw1394 code and
libdc1394 code yet.  I thought I post this stuff nevertheless in order
to gather your criticism...

Therefore I feel that this is all too late to be pushed into mainline
before 2.6.29(-rc1).  I'd like to target 2.6.30(-rc1) now instead.  I
hope those who have been waiting for all of this for months don't murder
me for the repeated delays to get this released.

At least I runtime-tested the base changes related to reference counting
and spinlocks though.

These patches apply after several as yet uncommitted firewire patches,
most notably "firewire: cdev: use an idr rather than a linked list for
resources" as necessary infrastructure, and "firewire: standardize a
variable name" and "firewire: remove line breaks before function names"
as ones which presumable create conflicts if not applied before.

Coming as follow-ups:

[PATCH 01/11] firewire: cdev: reference-count client instances
[PATCH 02/11] firewire: cdev: unify names of struct types and of their instances
[PATCH 03/11] firewire: cdev: sort includes
[PATCH 04/11] firewire: core: topology header fix
[PATCH 05/11] firewire: cdev: add ioctls for isochronous resource management
[PATCH 06/11] firewire: cdev: add ioctls for manual iso resource management
[PATCH 07/11] firewire: cdev: add ioctl to query maximum transmission speed
[PATCH 08/11] firewire: cdev: add ioctl for broadcast write requests
[PATCH 09/11] firewire: cdev: restrict broadcast write requests to Units Space
[PATCH 10/11] firewire: cdev: extend transaction payload size check
[PATCH 11/11] firewire: cdev: replace some spin_lock_irqsave by spin_lock_irq

 drivers/firewire/fw-cdev.c        |  749 +++++++++++++++++++++---------
 drivers/firewire/fw-iso.c         |  176 ++++++-
 drivers/firewire/fw-topology.h    |    6 
 drivers/firewire/fw-transaction.h |    4 
 include/linux/firewire-cdev.h     |  133 ++++-
 5 files changed, 836 insertions(+), 232 deletions(-)

Please comment.
-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

