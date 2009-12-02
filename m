Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZLBWqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZLBWqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZLBWqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:46:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199AbZLBWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:46:03 -0500
Date: Wed, 2 Dec 2009 14:45:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] ipc: remove unreachable code in sem.c
Message-Id: <20091202144552.ea635692.akpm@linux-foundation.org>
In-Reply-To: <20091201070008.4311.16191.sendpatchset@localhost.localdomain>
References: <20091201070008.4311.16191.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 01:57:09 -0500
Amerigo Wang <amwang@redhat.com> wrote:

> This line is unreachable, remove it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 87c2b64..8439f2f 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -652,7 +652,6 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
>  	default:
>  		return -EINVAL;
>  	}
> -	return err;
>  out_unlock:
>  	sem_unlock(sma);
>  	return err;

If we're going to do that then there's no point in initialising `err':

--- a/ipc/sem.c~ipc-remove-unreachable-code-in-semc-fix
+++ a/ipc/sem.c
@@ -624,7 +624,7 @@ static unsigned long copy_semid_to_user(
 static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			 int cmd, int version, union semun arg)
 {
-	int err = -EINVAL;
+	int err;
 	struct sem_array *sma;
 
 	switch(cmd) {
_


you should have noticed this!
