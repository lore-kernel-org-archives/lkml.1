Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZGWIIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZGWIIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZGWIIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:08:39 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:41149 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZGWIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kz+ZQL22IuCxr3z45p1I2yOKvwRP3OevpwkgiC6EN4oQagA+INCeBepdr/qfdOhgOR
         t4rPIJQCq6+sgKvIiikaF9avyBXiL/2xXdlRrSqi8H66qBGUFbLHa2/3HJRrLOyqoISM
         Q673Ft2wiNot4mBFLmiwZO97q1HGCKvKUEcIE=
MIME-Version: 1.0
In-Reply-To: <524f69650907230044u5ab44c59y91bc9b808f5fd6c3@mail.gmail.com>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
	 <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
	 <524f69650907222310h433cfe86vaef63c8ea2e56d56@mail.gmail.com>
	 <d8bd05e00907222324q26b8faa0i2d85f4d7e35d8198@mail.gmail.com>
	 <524f69650907230044u5ab44c59y91bc9b808f5fd6c3@mail.gmail.com>
Date: Thu, 23 Jul 2009 10:08:35 +0200
Message-ID: <d8bd05e00907230108j5efae098vcb683e934138625d@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, wireshark not installed.
The strange thing is, that sometimes mounting succeeds. So it
should'nt be an issue with the root share (unless the server doesn't
always answer in the same way)
Here's a dmesg output with a successful mount. (had to try for several
times, unloading/loading of module cifs is not necessary)
The only diffs which might be the cause are different flags (64 vs 0
when unable to mount) in line 1 and a different Xid in line 2.

 fs/cifs/cifsfs.c: Devname: //BRKVN05/AtlasPM flags: 64
 fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 97 with uid: 0
 fs/cifs/connect.c: Username: aprol
 fs/cifs/connect.c: UNC: \\BRKVN05\AtlasPM ip: 10.5.12.105
 fs/cifs/connect.c: Socket created
 fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x2bc
 fs/cifs/connect.c: Existing smb sess not found
 fs/cifs/cifssmb.c: secFlags 0x7
 fs/cifs/transport.c: For smb_command 114
 fs/cifs/transport.c: Sending smb:  total_len 51
 fs/cifs/connect.c: Demultiplex PID: 31969
 fs/cifs/connect.c: rfc1002 length 0x6f
 fs/cifs/cifssmb.c: Dialect: 0
 fs/cifs/cifssmb.c: negprot rc 0
 fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1f3fd TimeAdjust: -7200
 fs/cifs/sess.c: sess setup type 2
 fs/cifs/transport.c: For smb_command 115
 fs/cifs/transport.c: Sending smb:  total_len 242
 fs/cifs/connect.c: rfc1002 length 0xc7
 fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
 fs/cifs/sess.c: ssetup rc from sendrecv2 is 0
 fs/cifs/sess.c: UID = 20482
 fs/cifs/sess.c: bleft 153
 fs/cifs/sess.c: words left: 0
 fs/cifs/sess.c: ssetup freeing small buf f031ae40
 fs/cifs/connect.c: CIFS Session Established successfully
 fs/cifs/connect.c: file mode: 0x5f7  dir mode: 0x1ff
 fs/cifs/transport.c: For smb_command 117
 fs/cifs/transport.c: Sending smb:  total_len 90
 fs/cifs/connect.c: rfc1002 length 0x42
 fs/cifs/connect.c: disk share connection
 fs/cifs/connect.c: Tcon flags: 0x1
 fs/cifs/connect.c: CIFS Tcon rc = 0
 fs/cifs/cifssmb.c: In QFSDeviceInfo
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 72
 fs/cifs/connect.c: rfc1002 length 0x44
 fs/cifs/cifssmb.c: In QFSAttributeInfo
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 72
 fs/cifs/connect.c: rfc1002 length 0x50
 fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 97) rc = 0
 fs/cifs/inode.c: CIFS VFS: in cifs_iget as Xid: 98 with uid: 0
 fs/cifs/inode.c: Getting info on
 fs/cifs/transport.c: For smb_command 50
 fs/cifs/transport.c: Sending smb:  total_len 78
 fs/cifs/connect.c: rfc1002 length 0xb8
 fs/cifs/inode.c: Old time 0
 fs/cifs/inode.c: New time 67264957

Gerhard

On Thu, Jul 23, 2009 at 9:44 AM, Steve French<smfrench@gmail.com> wrote:
> On Thu, Jul 23, 2009 at 1:24 AM, Gerhard
> Hintermayer<gerhard.hintermayer@gmail.com> wrote:
>> See my original post to LKML at http://lkml.org/lkml/2009/7/15/217.
>> You can see kernel version, and dmesg output (including cifsFYI set to
>> 7) there.
>> I did file a bug report to gentoo bug list and lkml. Shall I also do
>> so for bugzilla.samba.org ? I think it's more kernel related.
>>
>> The DebugData of the share I'm trying to mount (fortunaltely I got a
>
>> mount -t cifs -o user=aprol,password=*****,ip=10.5.12.105 //BRKVN05/AtlasPM /mnt/AtlasPM
>
> The mount syntax you listed in your post is a little strange with the
> mount options preceding rather than following the UNC name and device,
> ie rather than the usual:
>              mount.cifs {//unc-name} {mount-point} [-o options]
>
> It looks like the first 3/4 of mount succeeded (setting up a session,
> and connecting to the share) to the point of doing the lookup of the
> root directory of the share (which I don't see in your trace).
> Typically there have been the following reasons for that to fail:
> 1) the user has no permission on the root of the share
> or
> 2) the root of the share is a dfs referral to another server (this
> should work now, but was probably not supported a few kernel releases
> ago)
> or
> 3) the server reports that the root directory is not a directory (ie
> is a file for example)
>
> It may be that an earlier mount failed perhaps oopsing in the vfs, and
> that could have left an existing cifs session and tree connection
> which made it seem like a later mount worked (since it found an
> existing session) but that seems unlikely.
>
> It would be helpful to see if the client did a network request (in
> this case SMB transact2 Query Path Info) on the root directory of the
> share, so if you have a wireshark trace that would be useful.
> --
> Thanks,
>
> Steve
>
