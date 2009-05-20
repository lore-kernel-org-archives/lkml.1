Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZETG3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZETG3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZETG2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:28:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZETG2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:28:52 -0400
Subject: [PATCH 1/2 -tip] drm/i915: acpi/video.c fix section mismatch
 warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Eric Anholt <eric@anholt.net>, mjg@redhat.com,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 May 2009 11:56:08 +0530
Message-Id: <1242800768.3260.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently acpi_video_exit() is exported as well as using __exit which causes:

  WARNING: drivers/acpi/video.o(__ksymtab+0x0): Section mismatch in reference from the variable __ksymtab_acpi_video_exit to the function .exit.text:acpi_video_exit()
  The symbol acpi_video_exit is exported and annotated __exit
  Fix this by removing the __exit annotation of acpi_video_exit or drop the export.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/acpi/video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 810cca9..a79b885 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -2334,7 +2334,7 @@ static int __init acpi_video_init(void)
 	return acpi_video_register();
 }
 
-void __exit acpi_video_exit(void)
+void acpi_video_exit(void)
 {
 
 	acpi_bus_unregister_driver(&acpi_video_bus);
-- 
1.6.1.1



