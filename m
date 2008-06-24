Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYFXV7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYFXV7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYFXV5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:57:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:49473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbYFXV5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lQVZVbPjPgq6A1LWWBiJPhWpfwaIZW2vk+Z7GwgagkyqaRYakfm24dgskIVgh9itGM
         2xeENIR2jszjd01oqxeYwVJMCvFhyKGK8Lo/dmKJod2bNCwZbgVV6Cw0eiwYaa/i3nYB
         l0tPjHciASaCrJDZEAVh3DAzZBz3VNkXuQUqU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: change size if e820_update/remove_range
Date: Tue, 24 Jun 2008 14:58:38 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806241455.33199.yhlu.kernel@gmail.com> <200806241456.20753.yhlu.kernel@gmail.com> <200806241457.29607.yhlu.kernel@gmail.com>
In-Reply-To: <200806241457.29607.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241458.38624.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in case someone using crazy parameter while calling them.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 512f779..6445220 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -405,6 +405,9 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 
 	BUG_ON(old_type == new_type);
 
+	if (size > (ULLONG_MAX - start))
+		size = ULLONG_MAX - start;
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
@@ -436,6 +439,9 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 	int i;
 	u64 real_removed_size = 0;
 
+	if (size > (ULLONG_MAX - start))
+		size = ULLONG_MAX - start;
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
