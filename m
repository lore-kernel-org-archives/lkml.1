Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZEQT3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZEQT3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZEQT2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:28:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:64333 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZEQT2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=txWUBijt+/dvQvcLc7JOnQHo65ahfFz9a6O6bQ1ItFqeMMVQRK7uOd9LKpRyaBs1eS
         FKIm1wu+5k5RRLw2ViGX7Ua3DISuDs2gmDOhWeor/KdMfhCebakZJunTXlzkzzYm3XY4
         KGOf0ettASXX7ww4wtzuu5/MVXkHhoL8VTv7Q=
Subject: Re: 2.6.30-rc4: microcode: failed to init CPU1
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Content-Type: text/plain
Date: Sun, 17 May 2009 21:28:48 +0200
Message-Id: <1242588528.4814.6.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> [ ... ]
>> [ 6643.982900] microcode: failed to init CPU1
>> [ 6643.983528] CPU1 is up
>> [ 6643.984529] ACPI: Waking up from system sleep state S4
>> [ 6644.290917] pci 0000:00:1e.0: power state changed by ACPI to D0
>> [ 6644.291103] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
>> [ 6644.291139] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800001, writing 0x2800005)
>> [ 6644.291187] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
>> [ 6644.297593] pci 0000:00:07.0: PME# disabled
>>
>> Is this an error/problem?
>
> Not sure.
>
> CCing the people who have worked with the Intel microcode code recently.


does the error message disappear with the following patch applied?

Thanks in advance.


---


Subject: error handling inconsistency

Don't report an error in case there is simply no cached microcode update available when resuming.


p.s. the current version in -tip provides better error handling and doesn't have this problem.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 98c470c..4fe8c3c 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -307,7 +307,7 @@ static int microcode_resume_cpu(int cpu)
 	pr_debug("microcode: CPU%d resumed\n", cpu);
 
 	if (!uci->mc)
-		return 1;
+		return 0;
 
 	/*
 	 * Let's verify that the 'cached' ucode does belong


