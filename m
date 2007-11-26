Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXKZRBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXKZRBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXKZRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:01:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:13869 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbXKZRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tSTuaVE8KxMqDzp9o010N3mw6pe/7ZDtOxVGeXy+EHK02RYWgqjiqySLhVtST7thD6POFOpSRDFIxS+XvYgGz4xSNg+qkPvUrcXHERB9rxmpjz+8nAr/VHp81UYkiTkQuF9hVGRMZU2FZkdSxafAcskyvYSh73K7AB9MCC4mYQA=
Message-ID: <671c20540711260901w6662fcabv779ce4fc51ec3d14@mail.gmail.com>
Date: Mon, 26 Nov 2007 12:01:22 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Clarification re: outstanding IPC flaws
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

  Reading current kernel git ipc/sem.c I see the following comment:

--
 * - The previous code had two flaws:
...
 *   2) It did not wake up all zero waiting processes. We try to do
 *      better but only get the semops right which only wait for zero or
 *      increase. If there are decrement operations in the operations
 *      array we do the same as before.

--

I have some questions about this comment.

Most importantly - does this mean that if I have multiple processes
queued inside semop() calls with sem_val = -1 (also, if it matters,
SEM_UNDO flag is set), I can expect to eventually see none of the
queued processes woken up when whoever has the semaphore releases it?

If that's the case, is there any semop best-use example I should be
following for multiple multi-threaded processes sharing multiple
semaphores?

Currently I have some globally reachable semaphores doing semop calls
with SEM_UNDO.  They usually work fine with multiple processes waiting
on each other to lock the semaphore, but under certain circumstances a
semaphore will be released and none of the processes waiting on the
semaphore will be woken up.

Thanks in advance,
Tom Burns
Software Developer
