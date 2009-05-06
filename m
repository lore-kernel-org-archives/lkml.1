Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbZEFWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbZEFWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbZEFVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:45 -0400
Received: from kroah.org ([198.145.64.141]:57159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761007AbZEFVyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:59 2009
Message-Id: <20090506214759.015271804@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Thomas Tuttle <ttuttle@google.com>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 27/58] pagemap: require aligned-length, non-null reads of /proc/pid/pagemap
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=pagemap-require-aligned-length-non-null-reads-of-proc-pid-pagemap.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

commit 0816178638c15ce5472d39d771a96860dff4141a upstream.

The intention of commit aae8679b0ebcaa92f99c1c3cb0cd651594a43915
("pagemap: fix bug in add_to_pagemap, require aligned-length reads of
/proc/pid/pagemap") was to force reads of /proc/pid/pagemap to be a
multiple of 8 bytes, but now it allows to read 0 bytes, which actually
puts some data to user's buffer.  According to POSIX, if count is zero,
read() should return zero and has no other results.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Thomas Tuttle <ttuttle@google.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -663,6 +663,10 @@ static ssize_t pagemap_read(struct file 
 		goto out_task;
 
 	ret = 0;
+
+	if (!count)
+		goto out_task;
+
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_task;


