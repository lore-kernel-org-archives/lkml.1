Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbYD3WDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbYD3WDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762583AbYD3WD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765875AbYD3WDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NZViWeihb6tSjxnZEBX5duIkEtvuPTFzuSMng4wofVTT3kzDWLWmmyEUEwk/S054cGtu4GjIc7ZZd20pszmqZeHdBBiFqkHDosSaUdT3eI4IWRhImhZCj1sEdN3bWc0XjxwH8HS5apIJ9ivEGo0cHqnCIcaNaTyXCHfLglob0T0=
Subject: [PATCH 01/10] acpi: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:40 -0700
Message-Id: <1209593020.24729.111.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
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
1.5.5.1.305.g7c84


