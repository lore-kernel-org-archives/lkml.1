Return-Path: <linux-kernel-owner+w=401wt.eu-S935509AbYEVWqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509AbYEVWqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbYEVWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:45:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:17088 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762245AbYEVWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VXgzD6UfYDFmO3GO2FWuH86fPUNWPezD+lJBfZ4WERwwyWlh/1Q1Gx/gleWOEu4MR7cE7ssi/nDBVKXpuj+LlLhQbOa1nLNNv2kh4qk1WG8CZWc+f0IccBpDkp6CzzT4lmIUYfdRMKJFtp4vfv6bWN3Otir9bH/v7aWCXHsxEdY=
Subject: [PATCH 2/5] acpi: fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Brown, Len" <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:06 -0700
Message-Id: <1211496306.6888.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi/dispatcher/dsmethod.c:568:50: warning: Using plain integer as NULL pointer
drivers/acpi/executer/exmutex.c:329:30: warning: Using plain integer as NULL pointer
drivers/acpi/executer/exmutex.c:466:31: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/acpi/dispatcher/dsmethod.c |    2 +-
 drivers/acpi/executer/exmutex.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/dispatcher/dsmethod.c b/drivers/acpi/dispatcher/dsmethod.c
index e48a3ea..2509809 100644
--- a/drivers/acpi/dispatcher/dsmethod.c
+++ b/drivers/acpi/dispatcher/dsmethod.c
@@ -565,7 +565,7 @@ acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
 
 				acpi_os_release_mutex(method_desc->method.
 						      mutex->mutex.os_mutex);
-				method_desc->method.mutex->mutex.thread_id = 0;
+				method_desc->method.mutex->mutex.thread_id = NULL;
 			}
 		}
 
diff --git a/drivers/acpi/executer/exmutex.c b/drivers/acpi/executer/exmutex.c
index c873ab4..a8bf3d7 100644
--- a/drivers/acpi/executer/exmutex.c
+++ b/drivers/acpi/executer/exmutex.c
@@ -326,7 +326,7 @@ acpi_status acpi_ex_release_mutex_object(union acpi_operand_object *obj_desc)
 
 	/* Clear mutex info */
 
-	obj_desc->mutex.thread_id = 0;
+	obj_desc->mutex.thread_id = NULL;
 	return_ACPI_STATUS(status);
 }
 
@@ -463,7 +463,7 @@ void acpi_ex_release_all_mutexes(struct acpi_thread_state *thread)
 		/* Mark mutex unowned */
 
 		obj_desc->mutex.owner_thread = NULL;
-		obj_desc->mutex.thread_id = 0;
+		obj_desc->mutex.thread_id = NULL;
 
 		/* Update Thread sync_level (Last mutex is the important one) */
 
-- 
1.5.5.1.579.g4e43


