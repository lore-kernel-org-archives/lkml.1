Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZKTSfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZKTSfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZKTSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:35:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:48586 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZKTSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TUlsJ9fLh4SsHS8VoDWb8GaZH2amzYO0Fwj27Pwxa/WWIjQb9hFgFz9Pujdzp5lzrV
         idjErhkwRisfz+sI3ieea47Kfyc3QaGJj8Z/1uabEA2jYgio+A/tkqZqE1nZqYBcH0bP
         YZGkq4vdjCPqaa0zIDwBO0o9sfNat65aF2Tm4=
Message-ID: <4B06E477.3000503@gmail.com>
Date: Fri, 20 Nov 2009 19:48:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] thinkpad-acpi: should error return be nagative?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned error should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Is this maybe required?

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d93108d..03c0a56 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6313,7 +6313,7 @@ static int brightness_write(char *buf)
 	 * Doing it this way makes the syscall restartable in case of EINTR
 	 */
 	rc = brightness_set(level);
-	return (rc == -EINTR)? ERESTARTSYS : rc;
+	return (rc == -EINTR)? -ERESTARTSYS : rc;
 }
 
 static struct ibm_struct brightness_driver_data = {
