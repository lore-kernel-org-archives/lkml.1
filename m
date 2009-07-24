Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZGXXM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZGXXM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbZGXXM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:12:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50545 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbZGXXMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:12:25 -0400
Date: Fri, 24 Jul 2009 19:12:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: g.hintermayer@inode.at
Cc: <linux-kernel@vger.kernel.org>, smfrench@gmail.com
Subject: Re: WARNING: at fs/inode.c:362 invalidate_inodes tainting kernel
 while trying to mount cifs filesystem
Message-ID: <20090724191213.48f20943@tlielax.poochiereds.net>
In-Reply-To: <62.47.75.132.1248259046.wm@webmail.inode.at>
References: <62.47.75.132.1248259046.wm@webmail.inode.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 12:37:26 +0200 (CEST)
"Gerhard Hintermayer" <g.hintermayer@inode.at> wrote:

> Sorry to bump up this issue again, but I haven't got any reply neither
> here nor at gentoo bug list.
> please CC me, since I'm not on the list.
> 
> When trying to mount a Windows 2003  share via
> mount -t cifs -o user=aprol,password=*****,ip=10.5.12.105 //BRKVN05/AtlasPM
> /mnt/AtlasPM "mount: Not a directory" even though the mountpoint
> exists and is a valid directory
> 
> dmesg output (with cifsFYI set to 7):
> fs/cifs/cifsfs.c: Devname: //BRKVN05/AtlasPM flags: 0
>  fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 3 with uid: 0
>  fs/cifs/connect.c: Username: aprol
>  fs/cifs/connect.c: UNC: \\BRKVN05\AtlasPM ip: 10.5.12.105
>  fs/cifs/connect.c: Socket created
>  fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x2bc
>  fs/cifs/connect.c: Existing smb sess not found
>  fs/cifs/cifssmb.c: secFlags 0x7
>  fs/cifs/transport.c: For smb_command 114
>  fs/cifs/transport.c: Sending smb:  total_len 51
>  fs/cifs/connect.c: Demultiplex PID: 5083
>  fs/cifs/connect.c: rfc1002 length 0x6f
>  fs/cifs/cifssmb.c: Dialect: 0
>  fs/cifs/cifssmb.c: negprot rc 0
>  fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1f3fd TimeAdjust:
> -7200
>  fs/cifs/sess.c: sess setup type 2
>  fs/cifs/transport.c: For smb_command 115
>  fs/cifs/transport.c: Sending smb:  total_len 242
>  fs/cifs/connect.c: rfc1002 length 0xc7
>  fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
>  fs/cifs/sess.c: ssetup rc from sendrecv2 is 0
>  fs/cifs/sess.c: UID = 14336
>  fs/cifs/sess.c: bleft 153
>  fs/cifs/sess.c: words left: 0
>  fs/cifs/sess.c: ssetup freeing small buf edca9740
>  fs/cifs/connect.c: CIFS Session Established successfully
>  fs/cifs/connect.c: file mode: 0x5f7  dir mode: 0x1ff
>  fs/cifs/transport.c: For smb_command 117
>  fs/cifs/transport.c: Sending smb:  total_len 90
>  fs/cifs/connect.c: rfc1002 length 0x42
>  fs/cifs/connect.c: disk share connection
>  fs/cifs/connect.c: Tcon flags: 0x1
>  fs/cifs/connect.c: CIFS Tcon rc = 0
>  fs/cifs/cifssmb.c: In QFSDeviceInfo
>  fs/cifs/transport.c: For smb_command 50
>  fs/cifs/transport.c: Sending smb:  total_len 72
>  fs/cifs/connect.c: rfc1002 length 0x44
>  fs/cifs/cifssmb.c: In QFSAttributeInfo
>  fs/cifs/transport.c: For smb_command 50
>  fs/cifs/transport.c: Sending smb:  total_len 72
>  fs/cifs/connect.c: rfc1002 length 0x50
>  fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 3) rc = 0
> ------------[ cut here ]------------
> WARNING: at fs/inode.c:362 invalidate_inodes+0xa6/0xe1()
> Hardware name: PowerEdge 2950
> Modules linked in: cifs nfsd exportfs ncpfs bonding floppy e1000e bnx2
> thermal button processor thermal_sys e1000 nfs lockd sunrpc usbhid sg
> scsi_wait_scan [last unloaded: cifs]
> Pid: 5082, comm: mount Tainted: G        W  2.6.29-gentoo-r5 #1
> Call Trace:
>  [<c011d251>] warn_slowpath+0x71/0xa8
>  [<c01158f6>] ? __wake_up+0x31/0x3b
>  [<f84bc7b0>] ? cifs_init_once+0xe/0x16 [cifs]
>  [<c01587e3>] ? cache_alloc_refill+0x62/0x434
>  [<c0170283>] ? generic_sync_sb_inodes+0x395/0x3a5
>  [<c01301de>] ? lowest_in_progress+0x43/0x4b
>  [<c016982a>] invalidate_inodes+0xa6/0xe1
>  [<c015c96b>] generic_shutdown_super+0x3c/0xda
>  [<c015ca4c>] kill_anon_super+0x12/0x31
>  [<c015cabc>] deactivate_super+0x35/0x47
>  [<c016c05e>] mntput_no_expire+0xc6/0xe6
>  [<c016c91d>] do_add_mount+0xd0/0xd8
>  [<c016d511>] do_mount+0x631/0x654
>  [<c0142138>] ? __get_free_pages+0x1e/0x24
>  [<c016bc53>] ? copy_mount_options+0x2a/0xf9
>  [<c016d59e>] sys_mount+0x6a/0xa8
>  [<c0102cc5>] sysenter_do_call+0x12/0x25
> ---[ end trace ea473e21e738f567 ]---
>  fs/cifs/cifsfs.c: In cifs_put_super
>  fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 4 with uid: 0
>  fs/cifs/cifssmb.c: In tree disconnect
>  fs/cifs/transport.c: For smb_command 113
>  fs/cifs/transport.c: Sending smb:  total_len 39
>  fs/cifs/connect.c: rfc1002 length 0x27
>  fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 5 with uid: 0
>  fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
>  fs/cifs/transport.c: For smb_command 116
>  fs/cifs/transport.c: Sending smb:  total_len 43
>  fs/cifs/connect.c: rfc1002 length 0x2b
> 

Sorry I didn't see this before...

This is pretty odd since it looks like the mount actually succeeded.
The call chain is something like:

do_mount
    do_new_mount
        do_kern_mount
        do_add_mount

...do_kern_mount apparently returned success, but then do_add_mount
ended up doing a mntput and tearing down the superblock (probably one
of the "goto unlock" clauses in there).

Did the mount syscall return any errors? stracing the mount command
should tell you this... Also like Steve said, getting a capture of the
traffic between the client and server when it fails may tell us something.

The fact that it only fails sometimes is a little worrisome though.
That means that either the server is behaving erratically or we have an
intermittent bug (maybe mem corruption or some sort of race). I've not
seen this problem in my testing, any legwork you can do to track it
down would be most helpful.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
