Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0CLABK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:01:10 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8418 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:01:06 -0500
Subject: [PATCH v1 0/3] [RFC] resource, PCI: work around pci=use_crs conflicts
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
Date: Thu, 11 Mar 2010 17:01:03 -0700
Message-ID: <20100311235954.4355.23100.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are to fix this pci=use_crs regression:

    http://bugzilla.kernel.org/show_bug.cgi?id=15480

The problem is that BIOS reported a PCI host bridge window that overlaps
system RAM.  This workaround trims the window to avoid the overlap, which
requires information about the conflicting resource.

Yanko, I reworked these a bit, so if you have a chance to retest them
and collect another dmesg log, I'd appreciate it.

I'm still hoping for someone to find out how Windows deals with this, but
haven't gotten any data yet.

---

Bjorn Helgaas (3):
      resources: add interfaces that return conflict information
      x86/PCI: trim _CRS windows when they conflict with previous reservations
      PCI: for address space collisions, show conflicting resource


 arch/x86/pci/acpi.c     |   48 ++++++++++++++++++++++++++++++++++-------------
 drivers/pci/setup-res.c |   14 ++++++++------
 include/linux/ioport.h  |    2 ++
 kernel/resource.c       |   44 ++++++++++++++++++++++++++++++++++++-------
 4 files changed, 82 insertions(+), 26 deletions(-)
