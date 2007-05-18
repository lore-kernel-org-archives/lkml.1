Return-Path: <linux-kernel-owner+w=401wt.eu-S1760213AbXERPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760213AbXERPDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXERPDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:03:30 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:44670 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXERPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:03:29 -0400
Message-ID: <464DC019.6010008@free.fr>
Date: Fri, 18 May 2007 17:02:49 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Dumping the checksums in a module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm getting "disagrees about version of symbol struct_module" messages, 
and I'm trying to understand why.

As far as I understand (which is not very far), if I define 
CONFIG_MODVERSIONS, then checksums for various functions (all exported 
functions?) and various structures (which ones?) will be included inside 
the kernel image, and written to Module.symvers. When an out-of-tree 
module is built, it will also include these checksums.

How do I list the checksums within a module?

$ /sbin/modinfo -V
module-init-tools version 3.2.2

$ uname -a
Linux venus 2.6.18.6 #1 PREEMPT Thu Feb 8 18:04:49 CET 2007 i686 
pentium4 i386 GNU/Linux

$ /sbin/modinfo test.ko
filename:       test.ko
vermagic:       2.6.20.7-rt8 preempt mod_unload PENTIUMIII REGPARM
depends:
parm:           pConfig_file:charp
parm:           allocator_himem:An integer (int)
parm:           EnableIdleMode:An integer (int)
parm:           Board_ID:An integer (int)
parm:           Diagnostic:An integer (int)

$ hexdump -C test.ko | grep -A2 struct_
000752e0  17 98 07 0e 73 74 72 75  63 74 5f 6d 6f 64 75 6c 
|....struct_modul|
000752f0  65 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|e...............|
00075300  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|

I think this means that, in this module, the checksum for symbol 
struct_module is 0x1798070e, right?

Is there a simpler way to list all the checksums?

Regards.
