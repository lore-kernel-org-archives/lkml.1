Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZI1HH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZI1HH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZI1HH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:07:27 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39876 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZI1HH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:07:27 -0400
Message-ID: <4AC060AE.1090401@gmail.com>
Date: Mon, 28 Sep 2009 09:07:26 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 28 Sep 2009 09:07:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> Go wild, test it out, and let us know about any regressions you find,
> 
>
Hi Linus

Something seems wrong with process time accounting.

Following program should consume 10*8 seconds of cpu on a 8 cpu machine, but
with 2.6.32-rc1 numbers are crazy.

$ gcc -O2 -o process process.c -lpthread
$ ./process
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:08 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:05 -
    - -        Rl+    0:05 -
    - -        Rl+    0:09 -
    - -        Rl+    0:05 -
    - -        Rl+    0:05 -
    - -        Rl+    0:05 -
    - -        Rl+    0:05 -
    - -        Rl+    0:01 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:16 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:14 -
    - -        Rl+    0:06 -
    - -        Rl+    0:14 -
    - -        Rl+    0:10 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:10 -
    - -        Rl+    0:02 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:24 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:20 -
    - -        Rl+    0:11 -
    - -        Rl+    0:24 -
    - -        Rl+    0:15 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:24 -
    - -        Rl+    0:03 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:32 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:29 -
    - -        Rl+    0:12 -
    - -        Rl+    0:29 -
    - -        Rl+    0:21 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:29 -
    - -        Rl+    0:04 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:40 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:35 -
    - -        Rl+    0:13 -
    - -        Rl+    0:35 -
    - -        Rl+    0:26 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:35 -
    - -        Rl+    0:05 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:48 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:40 -
    - -        Rl+    0:14 -
    - -        Rl+    0:40 -
    - -        Rl+    0:31 -
    - -        Rl+    0:10 -
    - -        Rl+    0:10 -
    - -        Rl+    0:40 -
    - -        Rl+    0:06 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      0:56 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:45 -
    - -        Rl+    0:15 -
    - -        Rl+    0:45 -
    - -        Rl+    0:37 -
    - -        Rl+    0:11 -
    - -        Rl+    0:11 -
    - -        Rl+    0:45 -
    - -        Rl+    0:07 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      1:05 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:51 -
    - -        Rl+    0:21 -
    - -        Rl+    0:55 -
    - -        Rl+    0:46 -
    - -        Rl+    0:12 -
    - -        Rl+    0:12 -
    - -        Rl+    0:59 -
    - -        Rl+    0:08 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      1:13 ./process
    - -        Sl+    0:00 -
    - -        Rl+    0:56 -
    - -        Rl+    0:22 -
    - -        Rl+    1:00 -
    - -        Rl+    0:52 -
    - -        Rl+    0:13 -
    - -        Rl+    0:13 -
    - -        Rl+    1:04 -
    - -        Rl+    0:09 -
  PID TTY      STAT   TIME COMMAND
 5532 pts/1    -      5:13 ./process
    - -        S+     5:13 -


$ cat process.c
#include <pthread.h>
#include <time.h>
#include <stdio.h>

/*
 * Burn cpu cycles for about 10 seconds
 */
static void *do_unit(void *arg)
{
        time_t t0,t1;

        t0 = time(NULL);
        do {
                t1 = time(NULL);
        } while (t1 - t0 <= 10);
        return NULL;
}




int main(int argc, char *argv[])
{
        pthread_t tids[8];
        int i;
        char cmd[128];

        sprintf(cmd, "ps m -p %d", getpid());
        for (i = 0; i < 8 ; i++)
                pthread_create(&tids[i], NULL, do_unit, NULL);
        for (i = 0; i < 9; i++) {
                sleep(1);
                system(cmd);
        }
        for (i = 0; i < 8 ; i++)
                pthread_join(tids[i], NULL);
        system(cmd);
        return 0;
}
