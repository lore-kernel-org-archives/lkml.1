Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbYENSDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbYENSDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYENSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYENSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:03:08 -0400
Date: Wed, 14 May 2008 11:01:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [BUG] 2.6.26-rc2-mm1 - kernel BUG at
 fs/reiserfs/journal.c:1414!
Message-Id: <20080514110145.93b7f780.akpm@linux-foundation.org>
In-Reply-To: <482AF14F.9060708@linux.vnet.ibm.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<482AF14F.9060708@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:33:59 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> While running the dbench benchmark on the reiserfs filesystem,
> over the x86_64 box booted with the 2.6.26-rc2-mm1 kernel. The
> Kernel BUG() is seen on the console.
> 
> ------------[ cut here ]------------
> kernel BUG at fs/reiserfs/journal.c:1414!

This?

--- a/fs/reiserfs/journal.c~reiserfs-convert-j_flush_sem-to-mutex-fix
+++ a/fs/reiserfs/journal.c
@@ -1412,7 +1412,7 @@ static int flush_journal_list(struct sup
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
 		mutex_lock(&journal->j_flush_mutex);
-	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
+	} else if (mutex_trylock(&journal->j_flush_mutex)) {
 		BUG();
 	}
 

