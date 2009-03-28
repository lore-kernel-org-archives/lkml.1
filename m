Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZC2Iv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZC2Iv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZC2Ivq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:51:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40084 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZC2Ivo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:51:44 -0400
References: <git-1238272225-dc85ce155b7cad4c39c1fc95b4f6281920cef3c8@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-ecbf61e7357d5c7047c813edd6983902d158688c@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:26 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] cumana: Fix a long standing bogon
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Should be using strncmp as the data from user space may be unterminated

(Bug #8004)

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/cumana_2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 68a6412..ed502b7 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -318,7 +318,7 @@ cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	int ret = length;
 
-	if (length >= 11 && strcmp(buffer, "CUMANASCSI2") == 0) {
+	if (length >= 11 && strncmp(buffer, "CUMANASCSI2", 11) == 0) {
 		buffer += 11;
 		length -= 11;
 
