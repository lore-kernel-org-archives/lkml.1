Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYJJKRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYJJKRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYJJKRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:17:31 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:47276 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYJJKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:17:30 -0400
Message-ID: <48EF2BAB.1010009@fr.ibm.com>
Date: Fri, 10 Oct 2008 12:17:15 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arnd@arndb.de
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel>
In-Reply-To: <20081009190406.1B257119@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -puN ipc/mqueue.c~no-checkpointing-for-sockets ipc/mqueue.c
> --- linux-2.6.git/ipc/mqueue.c~no-checkpointing-for-sockets	2008-10-09 11:56:58.000000000 -0700
> +++ linux-2.6.git-dave/ipc/mqueue.c	2008-10-09 11:56:58.000000000 -0700
> @@ -14,6 +14,7 @@
>   */
>  
>  #include <linux/capability.h>
> +#include <linux/checkpoint.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
>  #include <linux/file.h>
> @@ -655,6 +656,8 @@ asmlinkage long sys_mq_open(const char _
>  	char *name;
>  	int fd, error;
>  
> +	process_deny_checkpointing(current);
> +

mqueue being a file system, i would put the checks in the inode_operations.

Also, you can't always deny ! I would expect some allow in sys_mq_unlink().

C.
