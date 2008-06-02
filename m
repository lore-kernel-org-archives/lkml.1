Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYFBGb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYFBGb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFBGbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:31:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:51457 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYFBGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tUO6VuSR6dpGdD79Gm4bFhKS02NB136pqYwL/L7O5Hlb4FAxV56/+fDXnI6frIjMpu4eOblPutuNwG3ud7nO9dhNxo2izZNY0KfyOqpAY9ABUC6nYRMW4AfQdwN3nZkTkk87S3Dj3AHpvZVPCIF1xAj5A/OR4PoLq2MRDgaZU7g=
Message-ID: <19f34abd0806012331m7c57468bu820e9b6b0184836d@mail.gmail.com>
Date: Mon, 2 Jun 2008 08:31:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: find: WARNING: Hard link count is wrong for /proc/1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.26-rc4 seems to exhibit the following (new since at least 2.6.24)
warning when running find /proc/1:

find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
in your filesystem driver.  Automatically turning on find's -noleaf
option.  Earlier results may have failed to include directories that
should have been searched.

# ls -l /proc/1
total 0
-r-------- 1 root root 0 Jun  2 02:20 auxv
--w------- 1 root root 0 Jun  2 02:20 clear_refs
-r--r--r-- 1 root root 0 Jun  2 02:20 cmdline
-rw-r--r-- 1 root root 0 Jun  2 02:20 coredump_filter
lrwxrwxrwx 1 root root 0 Jun  2 02:20 cwd -> /
-r-------- 1 root root 0 Jun  2 02:20 environ
lrwxrwxrwx 1 root root 0 Jun  2 02:20 exe -> /bin/bash
dr-x------ 2 root root 0 Jun  2 02:20 fd
dr-x------ 2 root root 0 Jun  2 02:20 fdinfo
-r-------- 1 root root 0 Jun  2 02:20 limits
-r--r--r-- 1 root root 0 Jun  2 02:20 maps
-rw------- 1 root root 0 Jun  2 02:20 mem
-r--r--r-- 1 root root 0 Jun  2 02:20 mountinfo
-r--r--r-- 1 root root 0 Jun  2 02:20 mounts
-r-------- 1 root root 0 Jun  2 02:20 mountstats
dr-xr-xr-x 5 root root 0 Jun  2 02:20 net
-rw-r--r-- 1 root root 0 Jun  2 02:20 oom_adj
-r--r--r-- 1 root root 0 Jun  2 02:20 oom_score
-r-------- 1 root root 0 Jun  2 02:20 pagemap
lrwxrwxrwx 1 root root 0 Jun  2 02:20 root -> /
-r--r--r-- 1 root root 0 Jun  2 02:20 smaps
-r--r--r-- 1 root root 0 Jun  2 02:20 stat
-r--r--r-- 1 root root 0 Jun  2 02:20 statm
-r--r--r-- 1 root root 0 Jun  2 02:20 status
dr-xr-xr-x 3 root root 0 Jun  2 02:20 task
-r--r--r-- 1 root root 0 Jun  2 02:20 wchan

# stat /proc/1
  File: `/proc/1'
  Size: 0               Blocks: 0          IO Block: 1024   directory
Device: 3h/3d   Inode: 39          Links: 5
Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2008-06-02 02:19:07.418398897 -0400
Modify: 2008-06-02 02:19:07.418398897 -0400
Change: 2008-06-02 02:19:07.418398897 -0400

The other /proc/pid entries seem to have the same problem.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
