Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXKVDy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXKVDy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXKVDys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:54:48 -0500
Received: from gw.goop.org ([64.81.55.164]:34349 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXKVDys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:54:48 -0500
Message-ID: <4744FD87.7010301@goop.org>
Date: Wed, 21 Nov 2007 19:54:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: freeze vs freezer
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that a process blocked in a write to an xfs filesystem due to
xfs_freeze cannot be frozen by the freezer.

I see this if I suspend my laptop while doing something xfs-filesystem
intensive, like a kernel build.  My suspend scripts freeze the XFS
filesystem (as Dave said I should), which presumably blocks some writer,
and then the freezer times out and fails to complete.

Here's part of the process dump the freezer does when it times out:

cc1           D 00000000     0 18138  18137
       dd5f1e24 00200082 00000002 00000000 ecdeeb00 ecdeec64 c200f280 00000001 
       009c09a0 dd5f1e0c dd5f1e0c 0000000f 00000000 00000000 00000000 dd5f1e74 
       c7beb480 dd5f1e88 dd5f1ea8 c0228d97 e8889540 dd5f1e38 c015b75d dd5f1e44 
Call Trace:
 [<c0228d97>] xfs_write+0xf4/0x6d9
 [<c0226038>] xfs_file_aio_write+0x53/0x5b
 [<c0171c15>] do_sync_write+0xae/0xec
 [<c0172343>] vfs_write+0xa4/0x120
 [<c01728d7>] sys_write+0x3b/0x60
 [<c0106fae>] sysenter_past_esp+0x6b/0xa1
 =======================


I haven't looked at how to fix this yet.  I only just worked out why I
was getting suspend failures.

    J
