Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZLTTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZLTTXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZLTTX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:23:27 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16123 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZLTTXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:23:23 -0500
Subject: [PATCH 3/3] ACPI: processor: remove _PDC object list from struct
	acpi_processor
To: venkatesh.pallipadi@intel.com, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Sun, 20 Dec 2009 12:23:21 -0700
Message-ID: <20091220192321.5438.45589.stgit@bob.kio>
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
References: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we call _PDC, we get a handle to the processor, allocate the
object list buffer as needed, and free it immediately after calling
_PDC.

There's no need to drag around this object list with us everywhere
else, so let's just get rid of it.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 include/acpi/processor.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 7cc433d..0ea5ef4 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -224,8 +224,6 @@ struct acpi_processor {
 	struct acpi_processor_throttling throttling;
 	struct acpi_processor_limit limit;
 	struct thermal_cooling_device *cdev;
-	/* the _PDC objects for this processor, if any */
-	struct acpi_object_list *pdc;
 };
 
 struct acpi_processor_errata {

