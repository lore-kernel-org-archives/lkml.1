Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbYFGByx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbYFGByx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYFGByZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:54:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbYFGByA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IxoWrFbuw5Mgo/iH2LTGwsA2Mr+4mO+VuyGPrn63KHLeAojTKCTlLh3Yw+lanqdQlw
         Zkoox8uuqKP/M7Sq8QS6fL0mjuePwAaHtpYq9YPr/HEiFUxD00zCB++4dZBNg1uxF0JZ
         OA+IwWWN5Kqq421loi/sywvrCrHGy8uSbuYWM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: fix fail with 64g above system with numa32
Date: Fri, 6 Jun 2008 18:54:26 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031025.55026.yhlu.kernel@gmail.com> <200806031935.05202.yhlu.kernel@gmail.com> <200806061443.57488.yhlu.kernel@gmail.com>
In-Reply-To: <200806061443.57488.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061854.26421.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by : Yinghai Lu <yhlu.kernel@gmail.com>

--- a/arch/x86/kernel/srat_32.c	2008-06-06 17:37:51.000000000 -0700
+++ b/arch/x86/kernel/srat_32.c	2008-06-06 17:38:38.000000000 -0700
@@ -251,7 +251,7 @@ static int __init acpi20_parse_srat(stru
  
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
-		unsigned long end = node_end_pfn[nid];
+		unsigned long end = min(node_end_pfn[nid],max_pfn);
 
 		memory_present(nid, start, end);
 		node_remap_size[nid] = node_memmap_size_bytes(nid, start, end);
