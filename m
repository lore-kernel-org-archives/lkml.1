Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXC2JNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXC2JNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXC2JNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:13:40 -0400
Received: from ananas2.netvision.net.il ([199.203.100.203]:57302 "EHLO
	ntx.netvision.net.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753313AbXC2JNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:13:39 -0400
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: cifs causes BUG: soft lockup detected on CPU
Date: Thu, 29 Mar 2007 11:13:04 +0200
Message-ID: <58D14E53A4F69C4EAF4D29171C447CC4011AC783@NTX-CL.forest.netvision.net.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: cifs causes BUG: soft lockup detected on CPU
Thread-index: Acdx3/Ji4qHdfDg0QGeDZ+c38yVeIwAAHZIQ
From: "Valentin Zaharov" <karlos_@netvision.net.il>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Steven French" <sfrench@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your response!

I've tried different kernel versions.
Right now iam using generic 2.6.9-42 on one machine and 2.6.20.1 on
another one.
I also tried various distributions ( Suse, CentOS, RHEL4 ) - not sure it
is relevant.
Tried installing latest cifs modules, tried changing CIFSMaxBufSize to
15000,  without luck.
Freezes are totally random - sometimes they happen 2-4 times a day,
sometimes it can take 2 weeks.
Running cifs in debug mode gave following output right before crash (
should it come handy ):

Feb 16 22:12:16 UFR2 kernel:  fs/cifs/transport.c: Sending smb of length
178
Feb 16 22:12:16 UFR2 kernel:  fs/cifs/connect.c: rfc1002 length 0x6b)
Feb 16 22:12:16 UFR2 kernel:  fs/cifs/file.c: inode unchanged on server
Feb 16 22:12:16 UFR2 kernel:  fs/cifs/inode.c: Getting info on
\nv322600\www.newbyte.co.il\www\calculator.php
Feb 16 22:12:16 UFR2 kernel:  fs/cifs/inode.c: Old time 191743705
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: New time 191743712
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: File inode
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: Exclusive Oplock granted
on inode ec3d5830
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: leaving
cifs_open (xid = 199733193) rc = 0
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: in
cifs_user_read as Xid: 199733194 with uid: 501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/cifssmb.c: Reading 8192 bytes on
fid 16426
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: For smb_command 46
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: Sending smb:
total_len 63
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/connect.c: rfc1002 length 0x203f)
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: leaving
cifs_user_read (xid = 199733194) rc = 0
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: in
cifs_user_read as Xid: 199733195 with uid: 501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/cifssmb.c: Reading 8192 bytes on
fid 16426
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: For smb_command 46
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: Sending smb:
total_len 63
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/connect.c: rfc1002 length 0x203f)
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: leaving
cifs_user_read (xid = 199733195) rc = 0
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/file.c: CIFS VFS: in
cifs_user_read as Xid: 199733196 with uid: 501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/cifssmb.c: Reading 8192 bytes on
fid 16426
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: For smb_command 46
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: Sending smb:
total_len 63
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/connect.c: rfc1002 length 0x42b)
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/cifssmb.c: Reading 7188 bytes on
fid 16426
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: For smb_command 46
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/transport.c: Sending smb:
total_len 63
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/connect.c: rfc1002 length 0x3f)
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/misc.c: Null buffer passed
s/cifs/inode.c: CIFS VFS: in cifs_revalidate as Xid: 199733299 with uid:
501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: Revalidate:  inode
0xf5ecad2c count 1 dentry: 0xf5ec1f50 d_time 0 jiffies 191744725
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: CIFS VFS: leaving
cifs_revalidate (xid = 199733299) rc = 0
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: CIFS VFS: in
cifs_revalidate as Xid: 199733300 with uid: 501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: Revalidate: \nv9707 inode
0xee752060 count 1 dentry: 0xcb8f3604 d_time 191744714 jiffies 191744725
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: CIFS VFS: leaving
cifs_revalidate (xid = 199733300) rc = 0
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: CIFS VFS: in
cifs_revalidate as Xid: 199733301 with uid: 501
Feb 16 22:12:17 UFR2 kernel:  fs/cifs/inode.c: Revalidate: \nv9707 inode
0xee752060 count 1 dentry: 0xcb8f3604 d_time 191744714 jiffies 191744725

Let me know if you need more information

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, March 29, 2007 10:55 AM
To: Valentin Zaharov
Cc: linux-kernel@vger.kernel.org; Steven French
Subject: Re: cifs causes BUG: soft lockup detected on CPU

On Wed, 28 Mar 2007 20:35:55 +0200 "Valentin Zaharov"
<karlos_@netvision.net.il> wrote:

> Hi,
>  
> We have continous problem with server freezes. We are using cifs 
> mounts on apache powered web servers with content located on Win2k3
server.
> Servers freeze from time to time, producing following error just 
> before
> freeze:
> 
> Mar 26 21:50:37 UFR2 kernel:  CIFS VFS: cifs_strtoUCS: char2uni 
> returned
> -22 Mar 26 21:51:45 UFR2 last message repeated 55 times Mar 26 
> 21:52:49
> UFR2 last message repeated 30 times Mar 26 21:54:16 UFR2 last message 
> repeated 10 times Mar 26 21:56:13 UFR2 last message repeated 20 times 
> Mar 26 21:58:34 UFR2 last message repeated 75 times Mar 26 21:59:43 
> UFR2 last message repeated 30 times Mar 26 22:01:02 UFR2 last message 
> repeated 30 times Mar 26 22:02:04 UFR2 last message repeated 30 times 
> Mar 26 22:03:08 UFR2 last message repeated 50 times Mar 26 22:04:27 
> UFR2 last message repeated 10 times Mar 26 22:05:59 UFR2 last message 
> repeated 20 times Mar 26 22:07:10 UFR2 last message repeated 20 times 
> Mar 26 22:29:00 UFR2 last message repeated 64 times Mar 27 00:47:40 
> UFR2 last message repeated 15 times Mar 27 01:42:41 UFR2 last message 
> repeated 95 times Mar 27 02:15:57 UFR2 last message repeated 90 times 
> Mar 27 02:27:13 UFR2 last message repeated 45 times Mar 27 03:14:08 
> UFR2 last message repeated 95 times Mar 27 04:26:10 UFR2 last message 
> repeated 2 times Mar 27 06:11:35 UFR2 last message repeated 45 times 
> Mar
> 27 06:20:20 UFR2 last message repeated 15 times Mar 27 06:20:20 UFR2 
> last message repeated 12 times Mar 27 06:27:53 UFR2 kernel: BUG: soft 
> lockup detected on CPU#3!
> Mar 27 06:27:53 UFR2 kernel:  [<c0134b57>] softlockup_tick+0x9e/0xac 
> Mar
> 27 06:27:53 UFR2 kernel:  [<c0121440>] update_process_times+0x3b/0x5e 
> Mar 27 06:27:53 UFR2 kernel:  [<c010d885>] 
> smp_apic_timer_interrupt+0x6c/0x7a
> Mar 27 06:27:53 UFR2 kernel:  [<c01032ec>] 
> apic_timer_interrupt+0x28/0x30 Mar 27 06:27:53 UFR2 kernel:
> [<c0153d75>] generic_fillattr+0x75/0xa8 Mar 27 06:27:53 UFR2 kernel:
> [<f8e78ed2>] cifs_getattr+0x1e/0x2b [cifs] Mar 27 06:27:53 UFR2
kernel:
> [<f8e78eb4>] cifs_getattr+0x0/0x2b [cifs] Mar 27 06:27:53 UFR2 kernel:
> [<c0153dc9>] vfs_getattr+0x21/0x30 Mar 27 06:27:53 UFR2 kernel:
> [<c0153e93>] vfs_fstat+0x22/0x31 Mar 27 06:27:53 UFR2 kernel:
> [<c015443a>] sys_fstat64+0xf/0x23 Mar 27 06:27:53 UFR2 kernel:
> [<c0150fc5>] sys_open+0x1a/0x1c Mar 27 06:27:53 UFR2 kernel:
> [<c0102820>] sysenter_past_esp+0x5d/0x81 Mar 27 06:27:53 UFR2 kernel:
> [<c0310033>] xdr_xcode_array2+0x307/0x506 Mar 27 06:27:53 UFR2 kernel:

You didn't tell us what kernel version you're running.

Hanging in generic_fillattr: i_size_read() got stuck.  This is because
CIFS doesn't correctly hold i_mutex across i_size_write().

Steve, where are we up to with the fixes for that?
