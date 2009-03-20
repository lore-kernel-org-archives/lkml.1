Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbZCTTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbZCTTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZCTTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:10:28 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48069 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZCTTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:10:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=PwXRdp2zulNYdnlBgf0l251V/56kFAglkEe2wYT9iVV2ldIMpvrXGamb3+67BZ939l
         lkxmp3dn3dZU4Yu9W6WYkShkQ1nJZlKTii6peEgIJqZypQMTohNXrpxi2eOiCPfHt1kO
         InwMnaPmFt9hQMJDaPb1dSFX99MuCvu4JfQrE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix IO APIC resource allocation error message
Date: Fri, 20 Mar 2009 20:12:41 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090319; KDE/4.2.1; i686; ; )
Cc: Alan Bartlett <ajb.stxsl@googlemail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903202012.41344.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] x86: fix IO APIC resource allocation error message

Impact: fix incorrect error message

- IO APIC resource allocation error message contains one too many "be".

- Print the error message iff there are IO APICs in the system.

Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I've seen this error message for some time on my x86-32 laptop...

 arch/x86/kernel/io_apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/io_apic.c
===================================================================
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -4150,9 +4150,9 @@ static int __init ioapic_insert_resource
 	int i;
 	struct resource *r = ioapic_resources;
 
-	if (!r) {
+	if (!r && nr_ioapics > 0) {
 		printk(KERN_ERR
-		       "IO APIC resources could be not be allocated.\n");
+		       "IO APIC resources couldn't be allocated.\n");
 		return -1;
 	}
 
