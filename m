Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbYENOmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbYENOmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYENOlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:41:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:45630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYENOlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:41:49 -0400
Message-ID: <482AFA28.8020403@suse.com>
Date: Wed, 14 May 2008 10:41:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       kamalesh@linux.vnet.ibm.com
Subject: Re: [patch 2/3] [PATCH] reiserfs: convert j_flush_sem to mutex
References: <20080508063557.757413878@suse.com> <20080508063651.715221085@suse.com>
In-Reply-To: <20080508063651.715221085@suse.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney wrote:
>  j_flush_sem is a semaphore but uses it as if it were a mutex. This
>  patch converts it to a mutex.
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -1411,8 +1411,8 @@ static int flush_journal_list(struct sup
>  
>  	/* if flushall == 0, the lock is already held */
>  	if (flushall) {
> -		down(&journal->j_flush_sem);
> -	} else if (!down_trylock(&journal->j_flush_sem)) {
> +		mutex_lock(&journal->j_flush_mutex);
> +	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
>  		BUG();
>  	}

Oops. This chunk didn't get refreshed, here's the right one.

-Jeff

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1410,7 +1410,7 @@ static int flush_journal_list(struct sup
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
 		mutex_lock(&journal->j_flush_mutex);
-	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
+	} else if (mutex_trylock(&journal->j_flush_mutex)) {
 		BUG();
 	}
 


-- 
Jeff Mahoney
SUSE Labs
