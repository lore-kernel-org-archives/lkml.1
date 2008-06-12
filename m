Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYFLWPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYFLWPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYFLWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:15:08 -0400
Received: from as3.cineca.com ([130.186.84.211]:52835 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYFLWPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:15:07 -0400
Message-ID: <48519FDF.6010007@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH -mm] PAGE_ALIGN(): correctly handle 64-bit values on 32-bit
 architectures
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com>	<20080611121510.d91841a3.akpm@linux-foundation.org>	<485032C8.4010001@gmail.com>	<20080611134323.936063d3.akpm@linux-foundation.org>	<485055FF.9020500@gmail.com>	<20080611155530.099a54d6.akpm@linux-foundation.org>	<4850BE9B.5030504@linux.vnet.ibm.com>	<4850E3BC.308@gmail.com> <20080612020235.29a81d7c.akpm@linux-foundation.org> <485156B8.5070709@gmail.com>
In-Reply-To: <485156B8.5070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 00:14:53 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> I've tested the following patch on a i386 box with my usual .config and
> everything seems fine. I also tested allmodconfig and some randconfig builds and
> I've not seen any evident error.
> 
> I'll repeat the tests tonight on a x86_64. Other architectures should be tested
> as well...

x86_64 allmodconfig build failed due to a missing #include <linux/mm.h>
in arch/x86/kernel/module_64.c.

Following patch resolves (on top of the previous one).

Except this, no errors for x86_64.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
diff -urpN linux-2.6.25-rc5-mm3/arch/x86/kernel/module_64.c linux-2.6.25-rc5-mm3-fix-64-bit-page-align/arch/x86/kernel/module_64.c
--- linux-2.6.25-rc5-mm3/arch/x86/kernel/module_64.c	2008-06-13 00:05:51.000000000 +0200
+++ linux-2.6.25-rc5-mm3-fix-64-bit-page-align/arch/x86/kernel/module_64.c	2008-06-13 00:06:21.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
 
