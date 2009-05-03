Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZECBuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZECBuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZECBuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:50:37 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61025 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZECBug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WNVyVcdHjX0Ny5Ryp7x4hotyw5uoM8lzHlfnZ8HFtAb9D/wg/UboLjSQns1hFVNoRr
         N7ZJNUcTtRZk1ppIJOlwfvPbxMFKwwqUOOqmabdy6V+tgPL0qy+bx+bKM3hz8uRYbltX
         wsc9oXEoHcdBxw4dnZBuHpExfFjPTqtuVL/5k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/2][GIT PULL] tracing/filters: adjustements for strings
Date: Sun,  3 May 2009 03:50:31 +0200
Message-Id: <1241315433-7225-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset includes two little peas of features
for tracing filters, making them able to filter every kind of strings.

Now I can do this:

cd /debug/tracing
echo > trace
echo stacktrace > trace_options

cd events/lockdep
echo 'name == "&REISERFS_SB(s)->lock" && wait_usec > 0' > lock_acquired/filter

echo 1 > lock_acquired/enable
sleep 1
echo 0 > lock_acquired/enable

cat trace

 # tracer: nop
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
           <...>-6464  [000]   327.448232: lock_acquired: &REISERFS_SB(s)->lock (25058.984 us)
           <...>-6464  [000]   327.448233: 
 <= reiserfs_get_block
 <= __block_prepare_write
 <= block_write_begin
 <= reiserfs_write_begin
 <= generic_file_buffered_write
 <= __generic_file_aio_write_nolock
 <= generic_file_aio_write
           <...>-6470  [000]   327.448422: lock_acquired: &REISERFS_SB(s)->lock (25112.702 us)
           <...>-6470  [000]   327.448425: 
 <= reiserfs_update_sd_size
 <= reiserfs_write_end
 <= generic_file_buffered_write
 <= __generic_file_aio_write_nolock
 <= generic_file_aio_write
 <= do_sync_write
 <= reiserfs_file_write


Tom, your filter framework is awesome and very useful!
Thanks :-)

Frederic.
---

The following changes since commit a0e39ed378fb6ba916522764cd508fa7d42ad495:
  Heiko Carstens (1):
        tracing: fix build failure on s390

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/filters

Frederic Weisbecker (2):
      tracing/filters: support for filters of dynamic sized arrays
      tracing/filters: support for operator reserved characters in strings

 kernel/trace/trace_events_filter.c |   54 ++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 3 deletions(-)
