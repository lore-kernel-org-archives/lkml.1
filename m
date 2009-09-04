Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZIDTuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZIDTuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbZIDTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:50:09 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:34602 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757166AbZIDTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:50:08 -0400
Date: Fri, 4 Sep 2009 12:27:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: linux-kernel@vger.kernel.org
cc: samba@lists.samba.org
Subject: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on 32 bit x86 on a Dell 1950

After mouting a cifs share we have 5 second hiccups. Typical log output
when doing a simple "ls /mnt":

Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: For smb_command 50
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: Sending smb:
total_len 118
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving
cifs_revalidate (xid = 258) rc = 0
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: CIFS VFS: in cifs_lookup
as Xid: 263 with uid: 0
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: parent inode = 0xf58d2e60
name is: AutoWire.bmp and dentry = 0xf5adb63c
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: NULL inode in lookup
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: Full path: \AutoWire.bmp
inode = 0x(null)
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/inode.c: Getting info on \AutoWire.bmp
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: For smb_command 50
Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: Sending smb:  total_len 104

 ---- 5 second hiccup

Sep  4 16:21:48 rd-spare kernel:  fs/cifs/connect.c: rfc1002 length 0xce
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/connect.c: rfc1002 length 0xc0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: inode 0xf5876518 old_time=26000 new_time=32751
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: cifs_revalidate - inode unchanged
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/file.c: CIFS VFS: in cifs_writepages as Xid: 264 with uid: 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/file.c: CIFS VFS: leaving cifs_writepages (xid = 264) rc = 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate (xid = 262) rc = 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: in cifs_revalidate as Xid: 265 with uid: 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: Revalidate: \Akamai Headsets.doc inode 0xf5876518 count 2 dentry: 0xf5ada8d0 d_time 260
00 jiffies 32751
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate (xid = 265) rc = 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: in cifs_revalidate as Xid: 266 with uid: 0
Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: Revalidate: \Akamai Headsets.doc inode 0xf5876518 count 2 dentry: 0xf5ada8d0 d_time 260
00 jiffies 32751


This is happening intermittently on a variety of hosts.

cat /proc/fs/cifs/DebugData

Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.60
Active VFS Requests: 2
Servers:
1) Name: 10.2.4.64  Domain: W2K Uses: 1 OS: Windows Server 2003 R2 3790
Service Pack 2
	NOS: Windows Server 2003 R2 5.2	Capability: 0x1f3fd
	SMB session status: 1	TCP status: 1
	Local Users To Server: 1 SecMode: 0x3 Req On Wire: 2
	Shares:
	1) \\chiprodfs2\company Mounts: 1 Type: NTFS DevInfo: 0x20
Attributes: 0x700ff
PathComponentMax: 255 Status: 0x1 type: DISK

	MIDs:
	State: 2 com: 50 pid: 5951 tsk: f756d1b0 mid 277
	State: 2 com: 50 pid: 6044 tsk: f69d4760 mid 278

cat /proc/fs/cifs/Stats

Resources in use
CIFS Session: 1
Share (unique mount targets): 1
SMB Request/Response Buffer: 5 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Operations (MIDs): 2

0 session 0 share reconnects
Total vfs operations: 525 maximum at one time: 3

1) \\chiprodfs2\company
SMBs: 305 Oplock Breaks: 0
Reads:  0 Bytes: 0
Writes: 0 Bytes: 0
Flushes: 0
Locks: 0 HardLinks: 0 Symlinks: 0
Opens: 0 Closes: 0 Deletes: 0
Posix Opens: 0 Posix Mkdirs: 0
Mkdirs: 0 Rmdirs: 0
Renames: 0 T2 Renames 0
FindFirst: 2 FNext 0 FClose 0


What is this ???

