Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZALF5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZALF5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZALF5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:57:41 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:58642 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZALF5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xbrPC1Xi8Kz9BxIten9vDJ+pNjf5IP9bb2MnbmayzREbdwdoXXWTGXRjzp78jyr+tG
         LxP6SrZdVHkgd2nITAtbcInl5UtOI3dJ3Gt2RYerqcfMA7eV3F8lPx2NhvRlAdFrgGnE
         iRUSqRVObaFi+P+VkSCpQjOEbHhjUwnSrSoEY=
Message-ID: <b9df5fa10901112157j449d104fm1a1281a6bef409f9@mail.gmail.com>
Date: Mon, 12 Jan 2009 11:57:39 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] init: Reduce text space by removing a variable.
Cc: mingo@elte.hu, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce some text space.

We can carryout the function 'raid_setup' without the variable 'len'
and using a bit compiler optimization. Which also removes 8 bytes of
text space on my x86 system.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/init/do_mounts_md.c	2009-01-12 09:53:09.000000000 +0600
+++ linux-2.6/init/do_mounts_md.c	2009-01-12 11:12:39.734543784 +0600
@@ -243,17 +243,17 @@ static void __init md_setup_drive(void)

 static int __init raid_setup(char *str)
 {
-	int len, pos;
+	int pos;

-	len = strlen(str) + 1;
 	pos = 0;

-	while (pos < len) {
+	while (pos < strlen(str) + 1) {
 		char *comma = strchr(str+pos, ',');
 		int wlen;
 		if (comma)
 			wlen = (comma-str)-pos;
-		else	wlen = (len-1)-pos;
+		else	
+			wlen = strlen(str)-pos;

 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
