Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbXLGX66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbXLGX66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXLGX6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:58:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbXLGX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:58:50 -0500
Date: Fri, 7 Dec 2007 15:58:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.24-rc4-mm1 and /proc/<pid>/status Name: field
Message-Id: <20071207155816.25a00c41.akpm@linux-foundation.org>
In-Reply-To: <1197059203.15428.5.camel@localhost>
References: <1197059203.15428.5.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 20:26:43 +0000
Zan Lynx <zlynx@acm.org> wrote:

> Today I noticed pgrep doesn't work.  It seems the reason is a missing
> Name: tag in the status file for a process in /proc.
> 
> # cat /proc/1/status
> init
> State:  S (sleeping)
> Tgid:   1
> Pid:    1
> PPid:   0
> TracerPid:      0
> ...etc, etc...
> 
> This is supposed to look like:
> # cat /proc/1/status
> Name:	init
> State:	S (sleeping)
> Tgid:	1
> Pid:	1
> PPid:	0
> TracerPid:	0
> ...
> 

Thanks.  Two (more) bugs in
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3
+++ a/fs/proc/array.c
@@ -98,9 +98,9 @@ static inline void task_name(struct seq_
 
 	get_task_comm(tcomm, p);
 
+	seq_printf(m, "Name:\t");
 	end = m->buf + m->size;
 	buf = m->buf + m->count;
-	seq_printf(m, "Name:\n");
 	name = tcomm;
 	i = sizeof(tcomm);
 	while (i && (buf < end)) {
_

