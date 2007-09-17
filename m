Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbXIQRUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbXIQRUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXIQRUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:20:22 -0400
Received: from lucidpixels.com ([75.144.35.66]:58253 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbXIQRUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:20:19 -0400
Date: Mon, 17 Sep 2007 13:20:17 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: xfs@oss.sgi.com
Subject: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get
 dist-upgrade on Debian Testing
Message-ID: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1461406860-1190049617=:22156"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1461406860-1190049617=:22156
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Including the XFS mailing list in here too because it may be an XFS bug 
looking at the call trace.

System: Debian Testing
Kernel: 2.6.20
Config: Attached

I was running apt-get dist-upgrade as I always do to get the latest 
packages upgraded and the kernel OOPS'd when it was upgrading 'tzdata' and 
the process went into D-state and I had to reboot.

The config file is from 2.6.20 but it had been moved to a 2.6.22 directory 
for an upgrade, but all of the options have been left unchanged.

Here is the *OOPS I captured via dmesg before I rebooted:

[16201055.214559] nfsd: last server has exited
[16201055.214566] nfsd: unexporting all filesystems
[17341583.697472] BUG: unable to handle kernel paging request at virtual address 99e00750
[17341583.697480]  printing eip:
[17341583.697482] c01531b0
[17341583.697484] *pde = 00000000
[17341583.697488] Oops: 0000 [#1]
[17341583.697491] CPU:    0
[17341583.697493] EIP:    0060:[<c01531b0>]    Not tainted VLI
[17341583.697494] EFLAGS: 00210286   (2.6.20 #3)
[17341583.697502] EIP is at __d_lookup+0x5d/0xd6
[17341583.697505] eax: c8d7c17e   ebx: 99e00750   ecx: 00000011   edx: c17f9200
[17341583.697508] esi: 99e00750   edi: d2a10016   ebp: c7fe2304   esp: dba35d98
[17341583.697511] ds: 007b   es: 007b   ss: 0068
[17341583.697514] Process kdm_greet (pid: 22119, ti=dba34000 task=f52d4a70 task.ti=dba34000)
[17341583.697516] Stack: c8d7c17e 00000000 dba35e10 f705d478 dba35db8 0000002c d2a10016 d2a10042 
[17341583.697522]        dba35e10 dba35f30 dba35e10 c014ab6d dba35e1c c18c5240 dba35f04 c021877e 
[17341583.697528]        d2a10042 dba35e10 c8d7c17e dba35f30 c014c38f d2a10016 00000101 dba35e48 
[17341583.697534] Call Trace:
[17341583.697537]  [<c014ab6d>] do_lookup+0x1c/0x168
[17341583.697540]  [<c021877e>] xfs_vn_lookup+0x53/0x77
[17341583.697547]  [<c014c38f>] __link_path_walk+0x6e8/0xb1b
[17341583.697551]  [<c0153698>] dput+0x18/0x121
[17341583.697554]  [<c014c805>] link_path_walk+0x43/0xb8
[17341583.697558]  [<c014ca0a>] do_path_lookup+0x75/0x181
[17341583.697561]  [<c0145fda>] get_empty_filp+0x2f/0xe5
[17341583.697566]  [<c014d468>] __path_lookup_intent_open+0x45/0x80
[17341583.697570]  [<c014d517>] path_lookup_open+0x20/0x25
[17341583.697573]  [<c014d5db>] open_namei+0x66/0x58a
[17341583.697576]  [<c0143c35>] do_filp_open+0x25/0x40
[17341583.697580]  [<c0143c8e>] do_sys_open+0x3e/0xc7
[17341583.697584]  [<c0143d52>] sys_open+0x1c/0x20
[17341583.697587]  [<c0102920>] syscall_call+0x7/0xb
[17341583.697591]  =======================
[17341583.697593] Code: 81 f2 01 00 37 9e 8b 0d 18 3f 44 c0 d3 ea 31 d0 23 05 14 3f 44 c0 8b 15 1c 3f 44 c0 8b 34 82 85 f6 75 08 eb 4d 89 de 85 db 74 47 <8b> 1e 0f 18 03 90 8d 6e f4 8b 04 24 3b 45 18 75 e9 8b 44 24 0c 
[17341583.697621] EIP: [<c01531b0>] __d_lookup+0x5d/0xd6 SS:ESP 0068:dba35d98
[17341583.697626]  <1>BUG: unable to handle kernel paging request at virtual address 99e00750
[17341648.066740]  printing eip:
[17341648.066786] c01531b0
[17341648.066868] *pde = 00000000
[17341648.066916] Oops: 0000 [#2]
[17341648.066965] CPU:    0
[17341648.066966] EIP:    0060:[<c01531b0>]    Not tainted VLI
[17341648.066967] EFLAGS: 00010286   (2.6.20 #3)
[17341648.067115] EIP is at __d_lookup+0x5d/0xd6
[17341648.067165] eax: 1efcce0e   ebx: 99e00750   ecx: 00000011   edx: c17f9200
[17341648.067219] esi: 99e00750   edi: cc87901a   ebp: c7fe2304   esp: f7755f04
[17341648.067271] ds: 007b   es: 007b   ss: 0068
[17341648.067320] Process dpkg (pid: 24684, ti=f7754000 task=d9846a70 task.ti=f7754000)
[17341648.067371] Stack: 1efcce0e 46dd3a20 f7755f5c e489fe28 00000000 00000010 cc87901a 00000000 
[17341648.067715]        e489fe28 00000001 f7755f54 c014b7cb f7755f5c ef0d4098 ffffffd9 cc879000 
[17341648.068056]        00000001 f7755f54 c014cf84 f7755f54 e489fe28 c18c5240 1efcce0e 00000010 
[17341648.068397] Call Trace:
[17341648.068482]  [<c014b7cb>] __lookup_hash+0x4a/0xef
[17341648.068563]  [<c014cf84>] do_rmdir+0x69/0xbb
[17341648.068642]  [<c0102920>] syscall_call+0x7/0xb
[17341648.068724]  =======================
[17341648.068770] Code: 81 f2 01 00 37 9e 8b 0d 18 3f 44 c0 d3 ea 31 d0 23 05 14 3f 44 c0 8b 15 1c 3f 44 c0 8b 34 82 85 f6 75 08 eb 4d 89 de 85 db 74 47 <8b> 1e 0f 18 03 90 8d 6e f4 8b 04 24 3b 45 18 75 e9 8b 44 24 0c 
[17341648.070874] EIP: [<c01531b0>] __d_lookup+0x5d/0xd6 SS:ESP 0068:f7755f04
[17341648.070988]

I doubt I can reproduce it as it has happened after 180 days or so, and I 
am upgrading to 2.6.22.6 but I was wondering what exactly happened here?

Thanks!

Justin.
---1463747160-1461406860-1190049617=:22156
Content-Type: APPLICATION/octet-stream; name=config-2.6.22.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0709171320170.22156@p34.internal.lan>
Content-Description: 
Content-Disposition: attachment; filename=config-2.6.22.bz2

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
3TyhWg==

---1463747160-1461406860-1190049617=:22156--
