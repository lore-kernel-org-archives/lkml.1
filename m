Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYEAWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYEAWtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYEAWs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:48:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYEAWsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:48:55 -0400
Date: Thu, 1 May 2008 18:48:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH] fix irq flags in mac80211 code
Message-ID: <Pine.LNX.4.58.0805011847090.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A file in the net/mac80211 directory uses "int" for flags. This can
cause hard to find bugs on some architectures. This patch converts the
flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel
where checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 net/mac80211/rc80211_pid_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-compile.git/net/mac80211/rc80211_pid_debugfs.c
===================================================================
--- linux-compile.git.orig/net/mac80211/rc80211_pid_debugfs.c	2008-05-01 16:59:01.000000000 -0400
+++ linux-compile.git/net/mac80211/rc80211_pid_debugfs.c	2008-05-01 18:32:08.000000000 -0400
@@ -85,7 +85,7 @@ static int rate_control_pid_events_open(
 	struct rc_pid_sta_info *sinfo = inode->i_private;
 	struct rc_pid_event_buffer *events = &sinfo->events;
 	struct rc_pid_events_file_info *file_info;
-	unsigned int status;
+	unsigned long status;

 	/* Allocate a state struct */
 	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
@@ -135,7 +135,7 @@ static ssize_t rate_control_pid_events_r
 	char pb[RC_PID_PRINT_BUF_SIZE];
 	int ret;
 	int p;
-	unsigned int status;
+	unsigned long status;

 	/* Check if there is something to read. */
 	if (events->next_entry == file_info->next_entry) {

