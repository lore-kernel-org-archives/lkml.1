Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYEMPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYEMPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYEMPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:42:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759430AbYEMPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:42:03 -0400
Date: Tue, 13 May 2008 08:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/1] MAZE: Mazed processes monitor
Message-Id: <20080513084157.098ae2dc.akpm@linux-foundation.org>
In-Reply-To: <48297FD0.2090905@miraclelinux.com>
References: <48297FD0.2090905@miraclelinux.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 20:47:28 +0900 Hirofumi Nakagawa <hnakagawa@miraclelinux.com> wrote:

> Hi all.
> 
> This patch provides the mazed process monitor,named MAZE.
> MAZE's purpose is to notify or terminate registered processes when they are mazed.
> The definition of mazed process is a process using excessive CPU cycles,
> that is long time keeping TASK_RUNNING state.
> MAZE detects mazed processes and sends specified signals to them.
> This implements a CGL (Carrier Grade Linux) requirement (AVL.14.0).
> 
> Possible uses:
> * High-Availability system
> * system using many Real-Time processes such as embedded
> 
> Please any comments!
> 
> Hirofumi Nakagawa
> 
> --- Usage
> Add monitoring process.
> 
> % echo "1234 10000 20000 24 9" > /proc/maze/entries
> 
> The numeric values are "pid","soft limit [msec]","hard limit [msec]",
> "soft signal" and "hard signal".
> 
> 
> Get monitoring process list.
> 
> % cat /proc/maze/entries
> 
> --- Example
> As follows example express the feature of MAZE function.
> 
> --
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <unistd.h>
> 
> #include <stdio.h>
> #include <stdlib.h>
> 
> int main(int argc, char *argv[])
> {
>     int state,i;
>     char cmd[128];
> 
>     sprintf(cmd, "echo \"%d 10000 20000 24 9\" > /proc/maze/entries", getpid());
>     system(cmd);
> 
>     if (!fork()) {
>         printf("Mazed process start.\n");
>         for(;;);
>     }
> 
>     if (!fork()) {
>         printf("Not mazed process start.\n");
>         for(i = 0;i < 20; i++)
>             sleep(1);
>         printf("Not mazed process finish.\n");
>         exit(0);
>     }
> 
>     for (i = 0;i < 2; i++)
>          wait(&state);
> 
>     return 0;
> }

Please include (and maintain) all the above changelog information with
the patch itself rather than separately.  Because if I were to merge
this patch, I'd just have to copy-n-paste it all over anwyay.

Please send the text of AVL.14.0 (or a sufficient part of it for us to
understand the requirement) and maintain that within the changelog
also.

The immediate quesstion is, of course, "why does this need to be done
in-kernel?".  I am unable to answer that from the provided changelog
information, and I should be able to do that.

Thanks.
