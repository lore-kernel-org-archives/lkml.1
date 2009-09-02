Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZIBSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZIBSK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZIBSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:10:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40563 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZIBSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:10:26 -0400
Date: Wed, 2 Sep 2009 19:10:14 +0100
From: Matthew Garrett <mjg@redhat.com>
To: robert.moore@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Rework GPE handling
Message-ID: <20090902181014.GA10917@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current GPE code attempts to define GPEs as either runtime (the 
default), wake or run/wake. These states are orthogonal to whether or 
not a GPE is actually enabled or not. Further, various additional flags 
are defined and set, but never used.

This architecture is additionally complicated by changing the type of a 
GPE causing it to be disabled, resulting in complex functions that then 
have to conditionally re-enable a GPE. It also makes it impossible to 
determine how many consumers a given GPE has, preventing us from 
being able to implement runtime power management for devices requiring 
GPEs for wakeup notification.

This patchset adds a new, simpler API and transitions the existing users 
over to it. It then removes the old code.

 drivers/acpi/acpica/acevents.h |    6 -
 drivers/acpi/acpica/aclocal.h  |    2 
 drivers/acpi/acpica/evgpe.c    |  150 ++++---------------------------------
 drivers/acpi/acpica/evgpeblk.c |  164 +----------------------------------------
 drivers/acpi/acpica/evxface.c  |   14 ---
 drivers/acpi/acpica/evxfevnt.c |  139 ++++++++++++++++++++++++++++++++--
 drivers/acpi/button.c          |   18 +++-
 drivers/acpi/ec.c              |    5 -
 drivers/acpi/wakeup.c          |   57 +++-----------
 include/acpi/acpixf.h          |    8 ++
 include/acpi/actypes.h         |   32 ++------
 11 files changed, 197 insertions(+), 398 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
