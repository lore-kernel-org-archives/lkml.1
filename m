Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbZARHiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbZARHiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbZARHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:37:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55713 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760153AbZARHhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:37:12 -0500
Date: Sun, 18 Jan 2009 08:34:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, jaharkes@cs.cmu.edu
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/
Message-ID: <20090118073453.GA714@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs an ack from maintaner, I do not know where coda_in_hdr->pgid is used.

alloc_upcall() is the last user of deprecated task_pgrp_nr(), change it
to use task_pgrp_vnr() instead. Or it really needs the pid_t from the global
namespace?

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- CUR/fs/coda/upcall.c~3_CODA	2009-01-12 23:07:46.000000000 +0100
+++ CUR/fs/coda/upcall.c	2009-01-18 08:21:26.000000000 +0100
@@ -51,7 +51,7 @@ static void *alloc_upcall(int opcode, in
 
         inp->ih.opcode = opcode;
 	inp->ih.pid = current->pid;
-	inp->ih.pgid = task_pgrp_nr(current);
+	inp->ih.pgid = task_pgrp_vnr(current);
 	inp->ih.uid = current_fsuid();
 
 	return (void*)inp;

