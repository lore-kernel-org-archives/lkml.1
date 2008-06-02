Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYFBW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYFBW33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYFBW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:29:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:38889 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYFBW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RImvU8iltWZg7E3Z0az7cyAcNp9lOlrxwDUmn0074NzyTDCv1WOwoILPhmvxgItHHvSDZ3RojJZ8TQMo/vbOn5JAYlImDx7+14EUjBRAlMldjU/QQHKxdY861OIZAHNVw0H8oKj7U+fCSfybzIlnDkoGU/Otf6T5ENQu6XvTP/w=
Message-ID: <4844743A.3080000@gmail.com>
Date: Mon, 02 Jun 2008 19:29:14 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: find: WARNING: Hard link count is wrong for /proc/1
References: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
In-Reply-To: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> 2.6.26-rc4 seems to exhibit the following (new since at least 2.6.24)
> warning when running find /proc/1:
> 
> find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> in your filesystem driver.  Automatically turning on find's -noleaf
> option.  Earlier results may have failed to include directories that
> should have been searched.
> 
> # ls -l /proc/1
> total 0
> -r-------- 1 root root 0 Jun  2 02:20 auxv
> --w------- 1 root root 0 Jun  2 02:20 clear_refs
> -r--r--r-- 1 root root 0 Jun  2 02:20 cmdline
> -rw-r--r-- 1 root root 0 Jun  2 02:20 coredump_filter
> lrwxrwxrwx 1 root root 0 Jun  2 02:20 cwd -> /
> -r-------- 1 root root 0 Jun  2 02:20 environ
> lrwxrwxrwx 1 root root 0 Jun  2 02:20 exe -> /bin/bash
> dr-x------ 2 root root 0 Jun  2 02:20 fd
> dr-x------ 2 root root 0 Jun  2 02:20 fdinfo
> -r-------- 1 root root 0 Jun  2 02:20 limits
> -r--r--r-- 1 root root 0 Jun  2 02:20 maps
> -rw------- 1 root root 0 Jun  2 02:20 mem
> -r--r--r-- 1 root root 0 Jun  2 02:20 mountinfo
> -r--r--r-- 1 root root 0 Jun  2 02:20 mounts
> -r-------- 1 root root 0 Jun  2 02:20 mountstats
> dr-xr-xr-x 5 root root 0 Jun  2 02:20 net
> -rw-r--r-- 1 root root 0 Jun  2 02:20 oom_adj
> -r--r--r-- 1 root root 0 Jun  2 02:20 oom_score
> -r-------- 1 root root 0 Jun  2 02:20 pagemap
> lrwxrwxrwx 1 root root 0 Jun  2 02:20 root -> /
> -r--r--r-- 1 root root 0 Jun  2 02:20 smaps
> -r--r--r-- 1 root root 0 Jun  2 02:20 stat
> -r--r--r-- 1 root root 0 Jun  2 02:20 statm
> -r--r--r-- 1 root root 0 Jun  2 02:20 status
> dr-xr-xr-x 3 root root 0 Jun  2 02:20 task
> -r--r--r-- 1 root root 0 Jun  2 02:20 wchan
> 
> # stat /proc/1
>   File: `/proc/1'
>   Size: 0               Blocks: 0          IO Block: 1024   directory
> Device: 3h/3d   Inode: 39          Links: 5
> Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2008-06-02 02:19:07.418398897 -0400
> Modify: 2008-06-02 02:19:07.418398897 -0400
> Change: 2008-06-02 02:19:07.418398897 -0400
> 
> The other /proc/pid entries seem to have the same problem.
> 
> 
> Vegard
> 
The same warning shows up on linux 2.6.25.4.

$ sudo stat /proc/1
  File: `/proc/1'
  Size: 0         	Blocks: 0          IO Block: 1024   directory
Device: 3h/3d	Inode: 111976      Links: 5
Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-06-02 19:23:41.728134046 -0300
Modify: 2008-06-02 19:23:41.728134046 -0300
Change: 2008-06-02 19:23:41.728134046 -0300

This is the output of find before the warning shows up (it always happen
right after /proc/1/fdinfo/10):
$ sudo find /proc/1
/proc/1
/proc/1/task
/proc/1/task/1
/proc/1/task/1/fd
/proc/1/task/1/fd/10
/proc/1/task/1/fdinfo
/proc/1/task/1/fdinfo/10
/proc/1/task/1/environ
/proc/1/task/1/auxv
/proc/1/task/1/status
/proc/1/task/1/limits
/proc/1/task/1/cmdline
/proc/1/task/1/stat
/proc/1/task/1/statm
/proc/1/task/1/maps
/proc/1/task/1/mem
/proc/1/task/1/cwd
/proc/1/task/1/root
/proc/1/task/1/exe
/proc/1/task/1/mounts
/proc/1/task/1/clear_refs
/proc/1/task/1/smaps
/proc/1/task/1/pagemap
/proc/1/task/1/wchan
/proc/1/task/1/oom_score
/proc/1/task/1/oom_adj
/proc/1/fd
/proc/1/fd/10
/proc/1/fdinfo
/proc/1/fdinfo/10
find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
in your filesystem driver.  Automatically turning on find's -noleaf
option.  Earlier results may have failed to include directories that
should have been searched.
