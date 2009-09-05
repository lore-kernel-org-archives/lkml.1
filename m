Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZIELLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZIELLC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 07:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZIELLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 07:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317AbZIELLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 07:11:00 -0400
Date: Sat, 5 Sep 2009 07:10:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090905071052.50501826@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 12:27:35 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> This is on 32 bit x86 on a Dell 1950
> 
> After mouting a cifs share we have 5 second hiccups. Typical log output
> when doing a simple "ls /mnt":
> 
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: For smb_command 50
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: Sending smb:
> total_len 118
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving
> cifs_revalidate (xid = 258) rc = 0
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: CIFS VFS: in cifs_lookup
> as Xid: 263 with uid: 0
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: parent inode = 0xf58d2e60
> name is: AutoWire.bmp and dentry = 0xf5adb63c
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: NULL inode in lookup
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/dir.c: Full path: \AutoWire.bmp
> inode = 0x(null)
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/inode.c: Getting info on \AutoWire.bmp
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: For smb_command 50
> Sep  4 16:21:43 rd-spare kernel:  fs/cifs/transport.c: Sending smb:  total_len 104
> 
>  ---- 5 second hiccup
> 
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/connect.c: rfc1002 length 0xce
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/connect.c: rfc1002 length 0xc0

(adding linux-cifs-client mailing list)

It looks like it's just taking 5s for the server to respond here. Do
you happen to have a wire capture of one of these events? That may tell
us more than cifsFYI info...

> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: inode 0xf5876518 old_time=26000 new_time=32751
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: cifs_revalidate - inode unchanged
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/file.c: CIFS VFS: in cifs_writepages as Xid: 264 with uid: 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/file.c: CIFS VFS: leaving cifs_writepages (xid = 264) rc = 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate (xid = 262) rc = 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: in cifs_revalidate as Xid: 265 with uid: 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: Revalidate: \Akamai Headsets.doc inode 0xf5876518 count 2 dentry: 0xf5ada8d0 d_time 260
> 00 jiffies 32751
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate (xid = 265) rc = 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: CIFS VFS: in cifs_revalidate as Xid: 266 with uid: 0
> Sep  4 16:21:48 rd-spare kernel:  fs/cifs/inode.c: Revalidate: \Akamai Headsets.doc inode 0xf5876518 count 2 dentry: 0xf5ada8d0 d_time 260
> 00 jiffies 32751
> 
> 
> This is happening intermittently on a variety of hosts.
> 
> cat /proc/fs/cifs/DebugData
> 
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 1.60
> Active VFS Requests: 2
> Servers:
> 1) Name: 10.2.4.64  Domain: W2K Uses: 1 OS: Windows Server 2003 R2 3790
> Service Pack 2
> 	NOS: Windows Server 2003 R2 5.2	Capability: 0x1f3fd
> 	SMB session status: 1	TCP status: 1
> 	Local Users To Server: 1 SecMode: 0x3 Req On Wire: 2
> 	Shares:
> 	1) \\chiprodfs2\company Mounts: 1 Type: NTFS DevInfo: 0x20
> Attributes: 0x700ff
> PathComponentMax: 255 Status: 0x1 type: DISK
> 
> 	MIDs:
> 	State: 2 com: 50 pid: 5951 tsk: f756d1b0 mid 277
> 	State: 2 com: 50 pid: 6044 tsk: f69d4760 mid 278
> 
> cat /proc/fs/cifs/Stats
> 
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 1
> SMB Request/Response Buffer: 5 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Operations (MIDs): 2
> 
> 0 session 0 share reconnects
> Total vfs operations: 525 maximum at one time: 3
> 
> 1) \\chiprodfs2\company
> SMBs: 305 Oplock Breaks: 0
> Reads:  0 Bytes: 0
> Writes: 0 Bytes: 0
> Flushes: 0
> Locks: 0 HardLinks: 0 Symlinks: 0
> Opens: 0 Closes: 0 Deletes: 0
> Posix Opens: 0 Posix Mkdirs: 0
> Mkdirs: 0 Rmdirs: 0
> Renames: 0 T2 Renames 0
> FindFirst: 2 FNext 0 FClose 0
> 
> 
> What is this ???
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Jeff Layton <jlayton@redhat.com>
