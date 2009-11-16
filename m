Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZKPSl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZKPSl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZKPSl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:41:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38040 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZKPSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:41:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=u16fzJIMVLhRXaYtipLvLJa/xHIFvJFsTiAJvlap1+aBrLhee56gABH/IIO40p3Gk1
         qwsaY2W1wJJ4XclmNh79P+i55Rvhz+RCx+zTflkiR+PedIswbI8AEHP7fsez69M72qVC
         qm/F/NvH+Rol74RsitT7nGdcFGrKiI+Mhhf3M=
Message-ID: <4B019FC2.3060004@gmail.com>
Date: Mon, 16 Nov 2009 19:53:54 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] s390: ensure NUL termination by strncpy()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a larger source string, strncpy only NUL terminates when
the size argument is less than the size of the destination string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/s390/kernel/ipl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Is this maybe needed?

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 4890ac6..d52fcb4 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1881,7 +1881,7 @@ void __init setup_ipl(void)
 		break;
 	case IPL_TYPE_NSS:
 		strncpy(ipl_info.data.nss.name, kernel_nss_name,
-			sizeof(ipl_info.data.nss.name));
+			sizeof(ipl_info.data.nss.name) - 1);
 		break;
 	case IPL_TYPE_UNKNOWN:
 		/* We have no info to copy */
