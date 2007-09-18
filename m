Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXIRBpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXIRBpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXIRBps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:45:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46669 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbXIRBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:45:47 -0400
Date: Tue, 18 Sep 2007 11:45:37 +1000
From: David Chinner <dgc@sgi.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get dist-upgrade on Debian Testing
Message-ID: <20070918014537.GK23367404@sgi.com>
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 01:20:17PM -0400, Justin Piszcz wrote:
> Including the XFS mailing list in here too because it may be an XFS bug 
> looking at the call trace.
> 
> System: Debian Testing
> Kernel: 2.6.20
> Config: Attached
> 
> I was running apt-get dist-upgrade as I always do to get the latest 
> packages upgraded and the kernel OOPS'd when it was upgrading 'tzdata' and 
> the process went into D-state and I had to reboot.
> 
> The config file is from 2.6.20 but it had been moved to a 2.6.22 directory 
> for an upgrade, but all of the options have been left unchanged.
> 
> Here is the *OOPS I captured via dmesg before I rebooted:
> 
> [16201055.214559] nfsd: last server has exited
> [16201055.214566] nfsd: unexporting all filesystems
> [17341583.697472] BUG: unable to handle kernel paging request at virtual 
> address 99e00750
> [17341583.697480]  printing eip:
> [17341583.697482] c01531b0
> [17341583.697484] *pde = 00000000
> [17341583.697488] Oops: 0000 [#1]
> [17341583.697491] CPU:    0
> [17341583.697493] EIP:    0060:[<c01531b0>]    Not tainted VLI
> [17341583.697494] EFLAGS: 00210286   (2.6.20 #3)
> [17341583.697502] EIP is at __d_lookup+0x5d/0xd6
> [17341583.697505] eax: c8d7c17e   ebx: 99e00750   ecx: 00000011   edx: 
> c17f9200
> [17341583.697508] esi: 99e00750   edi: d2a10016   ebp: c7fe2304   esp: 
> dba35d98
> [17341583.697511] ds: 007b   es: 007b   ss: 0068
> [17341583.697514] Process kdm_greet (pid: 22119, ti=dba34000 task=f52d4a70 
> task.ti=dba34000)
> [17341583.697516] Stack: c8d7c17e 00000000 dba35e10 f705d478 dba35db8 
> 0000002c d2a10016 d2a10042 [17341583.697522]        dba35e10 dba35f30 
> dba35e10 c014ab6d dba35e1c c18c5240 dba35f04 c021877e [17341583.697528]     
> d2a10042 dba35e10 c8d7c17e dba35f30 c014c38f d2a10016 00000101 dba35e48 
> [17341583.697534] Call Trace:
> [17341583.697537]  [<c014ab6d>] do_lookup+0x1c/0x168
> [17341583.697540]  [<c021877e>] xfs_vn_lookup+0x53/0x77
> [17341583.697547]  [<c014c38f>] __link_path_walk+0x6e8/0xb1b
> [17341583.697551]  [<c0153698>] dput+0x18/0x121
> [17341583.697554]  [<c014c805>] link_path_walk+0x43/0xb8
> [17341583.697558]  [<c014ca0a>] do_path_lookup+0x75/0x181
> [17341583.697561]  [<c0145fda>] get_empty_filp+0x2f/0xe5
> [17341583.697566]  [<c014d468>] __path_lookup_intent_open+0x45/0x80
> [17341583.697570]  [<c014d517>] path_lookup_open+0x20/0x25
> [17341583.697573]  [<c014d5db>] open_namei+0x66/0x58a
> [17341583.697576]  [<c0143c35>] do_filp_open+0x25/0x40
> [17341583.697580]  [<c0143c8e>] do_sys_open+0x3e/0xc7
> [17341583.697584]  [<c0143d52>] sys_open+0x1c/0x20
> [17341583.697587]  [<c0102920>] syscall_call+0x7/0xb
> [17341583.697591]  =======================
> [17341583.697593] Code: 81 f2 01 00 37 9e 8b 0d 18 3f 44 c0 d3 ea 31 d0 23 
> 05 14 3f 44 c0 8b 15 1c 3f 44 c0 8b 34 82 85 f6 75 08 eb 4d 89 de 85 db 74 
> 47 <8b> 1e 0f 18 03 90 8d 6e f4 8b 04 24 3b 45 18 75 e9 8b 44 24 0c 
> [17341583.697621] EIP: [<c01531b0>] __d_lookup+0x5d/0xd6 SS:ESP 
> 0068:dba35d98
> [17341583.697626]  <1>BUG: unable to handle kernel paging request at 
> virtual address 99e00750
> [17341648.066740]  printing eip:
> [17341648.066786] c01531b0
> [17341648.066868] *pde = 00000000
> [17341648.066916] Oops: 0000 [#2]
> [17341648.066965] CPU:    0
> [17341648.066966] EIP:    0060:[<c01531b0>]    Not tainted VLI
> [17341648.066967] EFLAGS: 00010286   (2.6.20 #3)
> [17341648.067115] EIP is at __d_lookup+0x5d/0xd6
> [17341648.067165] eax: 1efcce0e   ebx: 99e00750   ecx: 00000011   edx: 
> c17f9200
> [17341648.067219] esi: 99e00750   edi: cc87901a   ebp: c7fe2304   esp: 
> f7755f04
> [17341648.067271] ds: 007b   es: 007b   ss: 0068
> [17341648.067320] Process dpkg (pid: 24684, ti=f7754000 task=d9846a70 
> task.ti=f7754000)
> [17341648.067371] Stack: 1efcce0e 46dd3a20 f7755f5c e489fe28 00000000 
> 00000010 cc87901a 00000000 [17341648.067715]        e489fe28 00000001 
> f7755f54 c014b7cb f7755f5c ef0d4098 ffffffd9 cc879000 [17341648.068056]     
> 00000001 f7755f54 c014cf84 f7755f54 e489fe28 c18c5240 1efcce0e 00000010 
> [17341648.068397] Call Trace:
> [17341648.068482]  [<c014b7cb>] __lookup_hash+0x4a/0xef
> [17341648.068563]  [<c014cf84>] do_rmdir+0x69/0xbb
> [17341648.068642]  [<c0102920>] syscall_call+0x7/0xb
> [17341648.068724]  =======================
> [17341648.068770] Code: 81 f2 01 00 37 9e 8b 0d 18 3f 44 c0 d3 ea 31 d0 23 
> 05 14 3f 44 c0 8b 15 1c 3f 44 c0 8b 34 82 85 f6 75 08 eb 4d 89 de 85 db 74 
> 47 <8b> 1e 0f 18 03 90 8d 6e f4 8b 04 24 3b 45 18 75 e9 8b 44 24 0c 
> [17341648.070874] EIP: [<c01531b0>] __d_lookup+0x5d/0xd6 SS:ESP 
> 0068:f7755f04
> [17341648.070988]
> 
> I doubt I can reproduce it as it has happened after 180 days or so, and I 
> am upgrading to 2.6.22.6 but I was wondering what exactly happened here?

No idea - it looks like dkpg was trying to remove a directory on the
same path the lookup was and both have gone splat in __d_lookup on
the same dentry. Something happened in  those 180 days that left a
landmine that was tripped over here, I think. I can't see any way of
tracking it down from this, but thanks for reporting it anyway,
Justin.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
