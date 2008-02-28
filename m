Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbYB1QRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbYB1QRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYB1QRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:17:14 -0500
Received: from mo-p07-fb.rzone.de ([81.169.146.191]:45994 "EHLO
	mo-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYB1QRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:17:13 -0500
X-Greylist: delayed 1950 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 11:17:13 EST
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: z4gQVF2k5XWuW3Cculz1E3jKuj8=
Date: Thu, 28 Feb 2008 16:44:12 +0100
From: Alex Riesen <raa.lkml@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai.lu@sun.com>
Subject: [PATCH] Fix "Malformed early option 'loglevel'"
Message-ID: <20080228154412.GA4784@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>, trivial@kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Rusty Russell in <1155086871.26428.5.camel@localhost.localdomain>:

    On Tue, 2006-08-08 at 17:10 -0700, Keith Mannthey wrote:
    > The parameter hotadd_percent is setup right but there is a
    > "Malformed early option 'numa'" message.

    For the record: this happens when the function registered with
    early_param() returns non-zero.  __setup() functions return 1 if OK,
    module_param() and early_param() return 0 or a -ve error code.
---

For instance:

Linux version 2.6.25-rc3-t (raa@steel) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #22 SMP PREEMPT Tue Feb 26
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Malformed early option 'loglevel'
127MB HIGHMEM available.
896MB LOWMEM available.

Command line:

BOOT_IMAGE=2.6.25-t ro root=809 ro console=ttyS0,57600n8 console=tty0 loglevel=5

 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8b19820..fbb0167 100644
--- a/init/main.c
+++ b/init/main.c
@@ -254,7 +254,7 @@ early_param("quiet", quiet_kernel);
 static int __init loglevel(char *str)
 {
 	get_option(&str, &console_loglevel);
-	return 1;
+	return 0;
 }
 
 early_param("loglevel", loglevel);
-- 
1.5.4.3.253.g9f1d5


