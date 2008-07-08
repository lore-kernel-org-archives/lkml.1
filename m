Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGHIpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGHIpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYGHIp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:45:27 -0400
Received: from mxsec.euro-web.fr ([81.93.243.199]:58733 "EHLO
	mxsec.euro-web.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYGHIpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:45:25 -0400
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel NULL pointer dereference at 00000023
Date: Tue, 8 Jul 2008 10:45:22 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081045.23158.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

There is a kernel bug on a server :
kernel is 2.6.25.4 (the sdf99-ipv6-core2 are justs strings added to makefile to describez config).
I will update to 2.6.25.10 soon on this box, but if this can help... 

If you need informations about the box... just ask.

=================
BUG: unable to handle kernel NULL pointer dereference at 00000023
IP: [<c01489f5>] unmap_vmas+0x151/0x5c8
*pdpt = 000000002491c001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 

Pid: 3766, comm: shtool Not tainted (2.6.25.4-sdf99-ipv6-core2 #2)
EIP: 0060:[<c01489f5>] EFLAGS: 00210206 CPU: 2
EIP is at unmap_vmas+0x151/0x5c8
EAX: 40193000 EBX: c1a42880 ECX: 00000017 EDX: 0000001f
ESI: 80000000 EDI: ed35f740 EBP: fff99c68 ESP: e7ce3ee8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process shtool (pid: 3766, ti=e7ce2000 task=f7d4cdb0 task.ti=e7ce2000)
Stack: 00000000 e7cfc5f4 e7ce3f64 00000000 00000000 00252e9b 4018d000 00000000 
       00000001 40193000 0000001f ed35f740 c361e100 fffffffc 00000000 c35ecbac 
       00000000 00000000 ca580000 4018d000 40193000 00000000 e7ce3f64 e8d2cddc 
Call Trace:
 [<c014be79>] exit_mmap+0x61/0xca
 [<c0118a9e>] mmput+0x20/0x74
 [<c011d011>] do_exit+0x1cc/0x535
 [<c011d3db>] do_group_exit+0x61/0x78
 [<c0103aaa>] syscall_call+0x7/0xb
 [<c0480000>] schedule+0x54a/0x587
 =======================
Code: 24 28 8b 74 24 18 8b 44 24 50 81 c6 00 00 00 40 81 e6 00 00 00 c0 48 89 f2 4a 39 c2 8b 44 24 50 8b 54 24 28 0f 42 c6 89 44 24 24 <8b> 5a 04 8b 0a 89 de 09 ce 74 1c 31 d2 89 c8 25 98 0f 00 00 89 
EIP: [<c01489f5>] unmap_vmas+0x151/0x5c8 SS:ESP 0068:e7ce3ee8
---[ end trace 7a550b72a5db8908 ]---
Fixing recursive fault but reboot is needed!
=================


even if this will not help you, this is the output before the bug.
the last line has never release, thaht why i have take a look to dmesg...
=== BEFORE THE BUG ===
[...]d/zend_operators.lo Zend/zend_ptr_stack.lo Zend/zend_stack.lo Zend/zend_variables.lo Zend/zend.lo Zend/zend_API.lo Zend/zend_extensions.lo Zend/zend_hash.lo Zend/zend_list.lo Zend/zend_indent.lo Zend/zend_builtin_functions.lo Zend/zend_sprintf.lo Zend/zend_ini.lo Zend/zend_qsort.lo Zend/zend_multibyte.lo Zend/zend_ts_hash.lo Zend/zend_stream.lo Zend/zend_iterators.lo Zend/zend_interfaces.lo Zend/zend_exceptions.lo Zend/zend_strtod.lo Zend/zend_objects.lo Zend/zend_object_handlers.lo Zend/zend_objects_API.lo Zend/zend_default_classes.lo Zend/zend_execute.lo sapi/cgi/fastcgi.lo sapi/cgi/cgi_main.lo sapi/cgi/getopt.lo main/internal_functions.lo -lcrypt -lcrypt -lhistory -lreadline -lncurses -lpanel -lncurses -lmysqlclient -lmcrypt -lltdl -lt1 -lfreetype -lpng -lz -ljpeg -ldb-4.3 -lgdbm -lcurl -lbz2 -lz -lresolv -lm -ldl -lnsl -lxml2 -lz -lm -lssl -lcrypto -ldl -lcurl -lxml2 -lz -lm -lcrypt -lxml2 -lz -lm -lcrypt  -o sapi/cgi/php-cgi

Build complete.
Don't forget to run 'make test'.

>>> Source compiled.
>>> Test phase [not enabled]: dev-lang/php-5.2.6-r2

>>> Install php-5.2.6-r2 into /var/tmp/portage/dev-lang/php-5.2.6-r2/image/ category dev-lang
Installing build environment:     /var/tmp/portage/dev-lang/php-5.2.6-r2/image//usr/lib/php5/lib/php/build/
Installing header files:          /var/tmp/portage/dev-lang/php-5.2.6-r2/image//usr/lib/php5/include/php/

=================


Best regards,
-- 
David CHANIAL
