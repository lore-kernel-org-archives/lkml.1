Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbZCaR7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbZCaR7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZCaR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:59:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53574 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZCaR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ll/k26tvbf3p+00IJp9ed7V7p6Q/fFJwWSv7ddVPaz58GjOC1Bx8E/iboO6YNix2DJ
         l84SMWj8xeQ5rJChh1vESN9HkAJa0QiNVLY+S5mbGTQ47PFRRog/DVC+C/hAXUrdUfTx
         ke+s9eJPe99Aw9Hg8R5F9yIinoUxQl9bQoOVk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] at91_ide: fix ->ftf_flags handling
Date: Tue, 31 Mar 2009 19:34:30 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311934.30792.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some incorrect IDE_FTFLAG_* changes which slipped in commit
"ide: add "flagged" taskfile flags to struct ide_taskfile (v2)"
(commit 19710d25d50ae0be05eebe4231ed8918b1092d82) few days ago.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/at91_ide.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -192,10 +192,10 @@ static void at91_ide_tf_load(ide_drive_t
 	struct ide_taskfile *tf = &cmd->tf;
 	u8 HIHI = (cmd->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (cmd->tf_flags & IDE_FTFLAG_FLAGGED)
+	if (cmd->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
-	if (cmd->tf_flags & IDE_FTFLAG_OUT_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
 
 		at91_ide_output_data(drive, NULL, &data, 2);
@@ -233,7 +233,7 @@ static void at91_ide_tf_read(ide_drive_t
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_taskfile *tf = &cmd->tf;
 
-	if (cmd->tf_flags & IDE_FTFLAG_IN_DATA) {
+	if (cmd->ftf_flags & IDE_FTFLAG_IN_DATA) {
 		u16 data;
 
 		at91_ide_input_data(drive, NULL, &data, 2);
