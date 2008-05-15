Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbYEOSo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbYEOSo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYEOSoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:44:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbYEOSop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:44:45 -0400
Message-ID: <482C838E.3030203@redhat.com>
Date: Thu, 15 May 2008 14:40:14 -0400
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
Subject: [PATCH] PCI: Correct last two HP entries in the bfsort whitelist
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

There is a code flaw in the bfsort whitelist, where there are redundant
entries for the same two HP systems, DL385 G2 and DL585 G2. This patch
replaces those redundant entries with the correct ones. The correct
entries are for large-volume systems, the DL360 and DL380.

-----------------------------------------------------------------------

commit ec69f0374c3b0ad7ea991b0e9ac00377acfe5b1a
Author: Tony Camuso <tony.camuso@hp.com>
Date:   Wed May 14 07:09:28 2008 -0400

     Replace Redundant Whitelist Entries with the Correct Ones

     The ProLiant DL585 G2 and the DL585 G2 are entered reundantly
     in the dmi_system_id table. What should have been there are the
     DL360 and DL380. This patch simply replaces the redundant
     entries with the correct entries.

          arch/x86/pci/common.c |    8 ++++----
          1 files changed, 4 insertions(+), 4 deletions(-)

     Signed-off-by: Tony Camuso <tony.camuso@hp.com>
     Signed-off-by: Pat Schoeller <patrick.schoeller@hp.com>

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 8545c8a..ee76b02 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -328,18 +328,18 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
  #endif
  	{
  		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL385 G2",
+		.ident = "HP ProLiant DL360",
  		.matches = {
  			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL360"),
  		},
  	},
  	{
  		.callback = set_bf_sort,
-		.ident = "HP ProLiant DL585 G2",
+		.ident = "HP ProLiant DL380",
  		.matches = {
  			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL380"),
  		},
  	},
  	{}
