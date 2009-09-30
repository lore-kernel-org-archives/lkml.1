Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZI3TF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZI3TF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZI3TFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:05:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63183 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZI3TFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=O+CuaiohODz7EFyi0UyUBuHiQXnZXBr3lEQIRCEY/5P15Omk4nQwuaKH56TgmcYsdJ
         V4yrtJ/ao4OCaCxYYQgppqmzfL4af2gh7avRQ3scLyBVfJSQAAwtgU4Klh73Tr4LsLY0
         VN0ALmWMoHM9AvE++Yc1fs/LUofyfXBWTVTms=
MIME-Version: 1.0
In-Reply-To: <20090928142903.GD17514@mit.edu>
References: <a769871e0909270527j5d4a6a51ycb5627ebe94704be@mail.gmail.com>
	 <20090928142903.GD17514@mit.edu>
Date: Wed, 30 Sep 2009 21:05:57 +0200
Message-ID: <a769871e0909301205x771e1fc3y62a25790e1728754@mail.gmail.com>
Subject: Re: ext4/reiser3/btr directory create/read perf
From: wbrana@gmail.com
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 4:29 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Sep 27, 2009 at 02:27:55PM +0200, wbrana@gmail.com wrote:
>> Hello,
>>
>> I executed benchmark which creates and reads 10000 directories.
>> It is much slower with ext4 than with reiser3 or btrfs.
>
> What precisely is your benchmark doing/measuring?  What are the times
> if you enable dir_index?
>
>                                        - Ted
>

I reduced benchmark to 10 directories and executed with strace

ext4
void cfs::vdirs_create(): 1047 msec
void cfs::vdirs_read(): 123 msec

vdirs_create():

mkdir("/mnt/md8/4", 0777)               = 0
mkdir("/mnt/md8/3", 0777)               = 0
mkdir("/mnt/md8/2", 0777)               = 0
mkdir("/mnt/md8/1", 0777)               = 0
mkdir("/mnt/md8/0", 0777)               = 0
sync()                                  = 0


vdirs_read():
QDir::entryInfoList() measured

stat("/mnt/md8", {st_dev=makedev(9, 8), st_ino=2,
st_mode=S_IFDIR|0755, st_nlink=8, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
lstat("/mnt/md8", {st_dev=makedev(9, 8), st_ino=2,
st_mode=S_IFDIR|0755, st_nlink=8, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
open("/mnt/md8", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 10
fstat(10, {st_dev=makedev(9, 8), st_ino=2, st_mode=S_IFDIR|0755,
st_nlink=8, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8,
st_size=4096, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
fcntl(10, F_GETFD)                      = 0x1 (flags FD_CLOEXEC)
statfs("/mnt/md8", {f_type="EXT2_SUPER_MAGIC", f_bsize=4096,
f_blocks=15484285, f_bfree=15438246, f_bavail=14651667,
f_files=3940352, f_ffree=3940336, f_fsid={-1324527978, -609145826},
f_namelen=255, f_frsize=4096}) = 0
getdents(10, {{d_ino=16386, d_off=399366477, d_reclen=24, d_name="1"}
{d_ino=8194, d_off=770605380, d_reclen=24, d_name="3"} {d_ino=11,
d_off=783174169, d_reclen=32, d_name="lost+found"} {d_ino=2,
d_off=1078596639, d_reclen=24, d_name="."} {d_ino=2, d_off=1358450504,
d_reclen=24, d_name=".."} {d_ino=8193, d_off=174337
5275, d_reclen=24, d_name="4"} {d_ino=16385, d_off=1786832028,
d_reclen=24, d_name="2"} {d_ino=24577, d_off=2147483647, d_reclen=24,
d_name="0"}}, 4096) = 200
stat("/mnt/md8/1", {st_dev=makedev(9, 8), st_ino=16386,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/1", {st_dev=makedev(9, 8), st_ino=16386,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/3", {st_dev=makedev(9, 8), st_ino=8194,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/3", {st_dev=makedev(9, 8), st_ino=8194,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/lost+found", {st_dev=makedev(9, 8), st_ino=11,
st_mode=S_IFDIR|0700, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=32, st_size=16384, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:29, st_ctime=2009/09/30-20:42:29}) = 0
stat("/mnt/md8/lost+found", {st_dev=makedev(9, 8), st_ino=11,
st_mode=S_IFDIR|0700, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=32, st_size=16384, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:29, st_ctime=2009/09/30-20:42:29}) = 0
stat("/mnt/md8/.", {st_dev=makedev(9, 8), st_ino=2,
st_mode=S_IFDIR|0755, st_nlink=8, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/.", {st_dev=makedev(9, 8), st_ino=2,
st_mode=S_IFDIR|0755, st_nlink=8, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:29,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/..", {st_dev=makedev(9, 2), st_ino=16,
st_mode=S_IFDIR|0755, st_nlink=36, st_uid=0, st_gid=0,
st_blksize=4096, st_blocks=1, st_size=952,
st_atime=2008/09/14-18:00:33, st_mtime=2009/09/19-17:44:10,
st_ctime=2009/09/19-17:44:10}) = 0
stat("/mnt/md8/..", {st_dev=makedev(9, 2), st_ino=16,
st_mode=S_IFDIR|0755, st_nlink=36, st_uid=0, st_gid=0,
st_blksize=4096, st_blocks=1, st_size=952,
st_atime=2008/09/14-18:00:33, st_mtime=2009/09/19-17:44:10,
st_ctime=2009/09/19-17:44:10}) = 0
stat("/mnt/md8/4", {st_dev=makedev(9, 8), st_ino=8193,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/4", {st_dev=makedev(9, 8), st_ino=8193,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/2", {st_dev=makedev(9, 8), st_ino=16385,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
getdents(10, {}, 4096)                  = 0
close(10)                               = 0
stat("/mnt/md8/2", {st_dev=makedev(9, 8), st_ino=16385,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0
stat("/mnt/md8/0", {st_dev=makedev(9, 8), st_ino=24577,
st_mode=S_IFDIR|0755, st_nlink=2, st_uid=0, st_gid=0, st_blksize=4096,
st_blocks=8, st_size=4096, st_atime=2009/09/30-20:42:45,
st_mtime=2009/09/30-20:42:45, st_ctime=2009/09/30-20:42:45}) = 0


Times with 10000 directories and dir_index enabled

/mnt/md8: 64 kB chunks
ext4
void cfs::vdirs_create(): 4996 msec
void cfs::vdirs_read(): 5100 msec


Times with 10000 files and dir_index enabled

/mnt/md8: 64 kB chunks
reiser3
void cfs::vfiles_create(): 1239 msec
void cfs::vdirs_read(): 409 msec
ext4
void cfs::vfiles_create(): 1464 msec
void cfs::vdirs_read(): 501 msec
btrfs
void cfs::vfiles_create(): 1295 msec
void cfs::vdirs_read(): 585 msec
