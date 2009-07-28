Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbZG1Ev6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbZG1Ev6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZG1Ev6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:51:58 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:63548 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZG1Ev5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:51:57 -0400
X-Greylist: delayed 1481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 00:51:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xE5rj/UBTZyCqorjvs4t5pYcwx/Cgpdew2IZbT3Y3Yk1dsZJX5vuhkQXwDfbZUiVGv
         OLdJz1IQ3PRmBDXvwM/P7d4TepvPm2ALTaKsTfyEERV8WOWwbmHRXYYEQBcax0Oanf7g
         +EUkK3mEPiF+w0/6sH8AGSxT9fgOkSWrhPr8w=
Message-ID: <4A6E7EB7.4090703@gmail.com>
Date: Mon, 27 Jul 2009 23:29:43 -0500
From: "Jory A. Pratt" <geekypenguin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090723 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-input@vger.kernel.org, akpm@linux-foundation.org
Subject: [RFC PATCH] Asus G1S noloop exception
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INPUT - Touchpad not detected on Asus G1S

The synaptic touchpad on the Asus G1S is not properly detected when 
rebooting machine
or on cold boot from time to time. Adding the Asus G1S to the noloop 
exception table resolves
the issue, as it allows the AUX IRQ to be rasied.

# dmidecode 2.10
SMBIOS 2.4 present.

Handle 0x0001, DMI type 1, 27 bytes
System Information
     Manufacturer: ASUSTeK Computer Inc.
     Product Name: G1S
     Version: 1.0
     Serial Number: NF1G7900340285
     UUID: 242481DC-61E7-7EFB-2480-001D606B6A5E
     Wake-up Type: Power Switch
     SKU Number:
     Family:

Signed-off-by: Jory A. Pratt <geekypenguin@gmail.com>

diff --git a/drivers/input/serio/i8042-x86ia64io.h 
b/drivers/input/serio/i8042-x86ia64io.h
index fb8a3cd..6723d04 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -78,6 +78,14 @@ static struct dmi_system_id __initdata 
i8042_dmi_noloop_table[] = {
                 },
         },
         {
+               .ident = "ASUS G1S",
+               .matches = {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer 
INC."),
+                       DMI_MATCH(DMI_BOARD_NAME, "G1S"),
+                       DMI_MATCH(DMI_BOARD_VERSION, "1.0"),
+               },
+       },
+       {
                 /* AUX LOOP command does not raise AUX IRQ */
                 .ident = "ASUS P65UP5",
                 .matches = {
