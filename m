Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZABNrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZABNrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbZABNrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:47:08 -0500
Received: from smtp.tal.de ([81.92.1.5]:33247 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282AbZABNrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:47:07 -0500
From: ib@wupperonline.de (Ingo Brueckl)
Date: Fri, 02 Jan 2009 14:42:00 +0100
Subject: [PATCH] compile time warnings
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <495e192c@wupperonline.de>
In-Reply-To: <20090102130140.GA30190@elte.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

 > yes, with a small nit:
>>
>> +static inline void permanent_kmaps_init(pgd_t *pgd_base)
>> +{
>> +     (void) pgd_base;

 > there's no need for this line - this is not a macro, so the function
 > parameter does not have to be 'used'.

I live and learn.


fix compiler warning in arch/x86/mm/init_32.c

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>

--- linux-2.6.28/arch/x86/mm/init_32.c.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/arch/x86/mm/init_32.c	2009-01-02 14:21:18.000000000 +0100
@@ -436,8 +436,12 @@ static void __init set_highmem_pages_ini
 #endif /* !CONFIG_NUMA */

 #else
-# define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init()	do { } while (0)
+static inline void permanent_kmaps_init(pgd_t *pgd_base)
+{
+}
+static inline void set_highmem_pages_init(void)
+{
+}
 #endif /* CONFIG_HIGHMEM */

 void __init native_pagetable_setup_start(pgd_t *base)
