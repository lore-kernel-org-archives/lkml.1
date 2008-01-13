Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbYAMIF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbYAMIF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 03:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYAMIFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 03:05:50 -0500
Received: from rosi.naasa.net ([212.8.0.13]:41556 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYAMIFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 03:05:49 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Sun, 13 Jan 2008 09:05:43 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801130032.32495.jplatte@naasa.net> <400206690.16519@ustc.edu.cn>
In-Reply-To: <400206690.16519@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801130905.44855.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 13. Januar 2008 schrieb Fengguang Wu:

> No idea yet :-/ I'm afraid I have to trouble you again - the bug just
> refused to appear in my system. I prepared a kernel module for you to
> gather more information:

> make && insmod ext2-writeback-debug.ko && sleep 1s && rmmod
> ext2-writeback-debug dmesg > ext2-writeback-debug.dmesg

Unfortunately, I unable to compile the module:

make -C /lib/modules/2.6.24-rc7-ext2/build SUBDIRS=/export/src modules
make[1]: Entering directory `/export/src/linux-2.6.24-rc7'
  CC [M]  /export/src/ext2-writeback-debug.o
/export/src/ext2-writeback-debug.c:89: error: variable ‘my_kprobe’ has 
initializer but incomplete type
/export/src/ext2-writeback-debug.c:90: error: unknown field ‘pre_handler’ 
specified in initializer
/export/src/ext2-writeback-debug.c:90: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:90: warning: (near initialization 
for ‘my_kprobe’)
/export/src/ext2-writeback-debug.c:91: error: unknown field ‘post_handler’ 
specified in initializer
/export/src/ext2-writeback-debug.c:91: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:91: warning: (near initialization 
for ‘my_kprobe’)
/export/src/ext2-writeback-debug.c:92: error: unknown field ‘symbol_name’ 
specified in initializer
/export/src/ext2-writeback-debug.c:93: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:93: warning: (near initialization 
for ‘my_kprobe’)
/export/src/ext2-writeback-debug.c:109: error: 
variable ‘jprobe_ext2_writepage’ has initializer but incomplete type
/export/src/ext2-writeback-debug.c:110: error: unknown field ‘entry’ specified 
in initializer
/export/src/ext2-writeback-debug.c:110: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:110: warning: (near initialization 
for ‘jprobe_ext2_writepage’)
/export/src/ext2-writeback-debug.c:111: error: unknown field ‘kp’ specified in 
initializer
/export/src/ext2-writeback-debug.c:112: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:112: warning: (near initialization 
for ‘jprobe_ext2_writepage’)
/export/src/ext2-writeback-debug.c:124: error: variable ‘jprobe_requeue_io’ 
has initializer but incomplete type
/export/src/ext2-writeback-debug.c:125: error: unknown field ‘entry’ specified 
in initializer
/export/src/ext2-writeback-debug.c:125: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:125: warning: (near initialization 
for ‘jprobe_requeue_io’)
/export/src/ext2-writeback-debug.c:126: error: unknown field ‘kp’ specified in 
initializer
/export/src/ext2-writeback-debug.c:127: warning: excess elements in struct 
initializer
/export/src/ext2-writeback-debug.c:127: warning: (near initialization 
for ‘jprobe_requeue_io’)
/export/src/ext2-writeback-debug.c: In function ‘setup_kprobe’:
/export/src/ext2-writeback-debug.c:132: error: dereferencing pointer to 
incomplete type
/export/src/ext2-writeback-debug.c: In function ‘setup_jprobe’:
/export/src/ext2-writeback-debug.c:139: error: dereferencing pointer to 
incomplete type
make[2]: *** [/export/src/ext2-writeback-debug.o] Error 1
make[1]: *** [_module_/export/src] Error 2
make[1]: Leaving directory `/export/src/linux-2.6.24-rc7'
make: *** [default] Error 2

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

