Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbZFPSkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbZFPSkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZFPSkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:40:12 -0400
Received: from www84.your-server.de ([213.133.104.84]:44406 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZFPSkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:40:11 -0400
Subject: [RFC] set the thread name
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 20:39:52 +0200
Message-Id: <1245177592.14543.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is not easy to identify a thread in linux, because there is
no thread name like in some other OS. 

If there were are thread name then we could extend a kernel segv message
and the /proc/<pid>/task/<tid>/... entries by a TName value like this:

cat /proc/492/task/495/status
Name:   test
TName:  RX-Data          <- this is the thread identification field
State:  S (sleeping)
Tgid:   492
Pid:    495
PPid:   1
.
.
.

This will it make much easier to determinate which thread id is
associated to a logical thread.

It would be possible do this without add a new entry to the task_struct.
Just use the comm entry which is available, because it has the same
value as the group_leader->comm entry.

The only thing to do is to replace all task_struct->comm access by
task_struct->group_leader->comm to have the old behavior. This can be
eventually encapsulated by a macro.

The task_struct->comm of a non group_leader would be than the name of
the thread.

The only drawback is that there are a lot of files which must be
modified. A quick
 find linux-2.6.30 -type f | xargs grep -l -e "->comm\>"  | wc -l
shows 215 files. But this can be handled.

So i propose a new system call to give a thread a name.

What do you think?

Greetings,
Stefani


