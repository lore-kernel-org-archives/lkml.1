Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbXJIK3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbXJIK3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 06:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXJIK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 06:28:54 -0400
Received: from mail.neti.ee ([194.126.101.114]:57703 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbXJIK2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 06:28:53 -0400
X-Greylist: delayed 1481 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Oct 2007 06:28:53 EDT
Message-ID: <470B511C.3070903@dot.ee>
Date: Tue, 09 Oct 2007 12:59:56 +0300
From: =?ISO-8859-1?Q?Andri_M=F6ll?= <andri@dot.ee>
User-Agent: Mutt/1.5.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CIFSd oops (Linux 2.6.22)
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morning,

Lately I've been having issues with one of my machines' CIFS mounts. Failure
seems rather random to me, but most often occurs after adding new torrents to
Azureus.

I see no irregular messages on my Samba server machine, and other machines can
access the server fine.

Dmesg:
 CIFS VFS: server not responding
 CIFS VFS: No response to cmd 46 mid 11858
 CIFS VFS: Send error in read = -11
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Send error in Close = -9
 ...same line repeated for a while...
 CIFS VFS: Send error in Close = -9
 CIFS VFS: server not responding
 CIFS VFS: No response to cmd 46 mid 17985
 CIFS VFS: Send error in read = -11
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Send error in Close = -9
 ...same line repeated for a while...
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Invalid size SMB length 4 pdu_length 1412112
 CIFS VFS: No response to cmd 46 mid 35861
 CIFS VFS: Send error in read = -11
 CIFS VFS: Send error in read = -9
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Invalid size SMB length 4 pdu_length 4
BUG: unable to handle kernel NULL pointer dereference at virtual address 000000c8
 printing eip:
c01e8f8c
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: nvidia(P) ext3 jbd
CPU:    0
EIP:    0060:[<c01e8f8c>]    Tainted: P       VLI
EFLAGS: 00010246   (2.6.22-gentoo-r8 #1)
eax: 000000c0   ebx: f54f1a00   ecx: 00000077   edx: 00000002
esi: 00000000   edi: 00000004   ebp: 00000233   esp: f5649f5c
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cifsd (pid: 3991, ti=f5648000 task=f54ce510 task.ti=f5648000)
Stack: 00000233 c011b757 c0402f2e 00000000 00000000 c01eb797 c0402f2e 00000004
       00000004 f54f1a00 ccb30000 db9b0000 c8069700 e5940480 d434c2c0 00000001
       735c3e80 0000000d 00000000 00000000 f5649fc0 00000001 00000000 00000000
Call Trace:
 [<c011b757>] <0> [<c01eb797>] <0> [<c0114fc4>] <0> [<c01eb473>] <0>
[<c0129feb>] <0> [<c0129fb3>] <0> [<c0104857>] <0> =======================
Code: 64 f6 05 20 aa 4f c0 01 74 19 8b 42 04 8b 12 c7 04 24 b5 20 40 c0 89 44 24
08 89 54 24 04 e8 b8 27 f3 ff 8b 43 30 ba 02 00 00 00 <8b> 48 08 ff 51 30 f6 05
20 aa 4f c0 01 74 1c 8b 43 30 8b 50 04
EIP: [<c01e8f8c>]  SS:ESP 0068:f5649f5c
 CIFS VFS: No response to cmd 47 mid 36433
 CIFS VFS: Write2 ret -11, written = 0
 CIFS VFS: Write2 ret -112, written = 0
 CIFS VFS: Write2 ret -112, written = 0
 CIFS VFS: Write2 ret -112, written = 0
 CIFS VFS: Write2 ret -112, written = 0
 CIFS VFS: Write2 ret -112, written = -290816
 CIFS VFS: Write2 ret -112, written = 4
 CIFS VFS: Write2 ret -112, written = -364646400
 CIFS VFS: Write2 ret -112, written = -364646400
 CIFS VFS: Write2 ret -112, written = -364646400
 CIFS VFS: Error 0xffffff90 on cifs_get_inode_info in lookup of /foo
 ...the above message repeats for dozens of times for various open files...

Closing all applications (otherwise unmounting fails due to open files) and then
remounting seems to "solve" this.


If replying, please CC to me.

Thank you in advance for any suggestions and ideas!

Andri
