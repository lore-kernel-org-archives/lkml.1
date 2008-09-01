Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYIAOTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYIAOTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIAOTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:19:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51111 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYIAOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:19:12 -0400
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce
	PRIO_THREAD extension
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1220278355.3866.21.camel@localhost.localdomain>
References: <1220278355.3866.21.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-NCfCbLjWwBz2/YpP80Vs"
Date: Mon, 01 Sep 2008 16:17:58 +0200
Message-Id: <1220278678.3866.27.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NCfCbLjWwBz2/YpP80Vs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-09-01 at 16:12 +0200, Denys Vlasenko wrote:
> Patch is run tested. I will post test program etc as a reply.

Test program is attached.
Build with "gcc -o prio_vda3 prio_vda3.c -lpthread".
Output:

start test program
CHILD1: TID:3269 getpriority:0
CHILD1: PID:3269 getpriority:0
setpriority(PRIO_PROCESS, 3269, -10)
THREAD CHILD: TID:3270 getpriority:-2
THREAD CHILD: PID:3269 getpriority:-10
THREAD CHILD: TID:3271 getpriority:-4
THREAD CHILD: PID:3269 getpriority:-10
THREAD CHILD: TID:3272 getpriority:-6
THREAD CHILD: PID:3269 getpriority:-10
THREAD CHILD: TID:3273 getpriority:-8
THREAD CHILD: PID:3269 getpriority:-10
CHILD2: TID:3269 getpriority:-10
CHILD2: PID:3269 getpriority:-10
Joined!
Joined!
Joined!
Joined!

log of instrumented kernel:

 (no threads created yet, only one tid exists)
 getpriority:
PRIO_PROCESS: pid 3269 tgid 3269: niceval=20
PRIO_PROCESS: returning retval=20
PRIO_PROCESS: pid 3269 tgid 3269: niceval=20
PRIO_PROCESS: returning retval=20
 (5 threads are created)
 setpriority(PRIO_PROCESS, pid, -10):
setting prio of pid 3269 tgid 3269 to -10
setting prio of pid 3270 tgid 3269 to -10
setting prio of pid 3271 tgid 3269 to -10
setting prio of pid 3272 tgid 3269 to -10
setting prio of pid 3273 tgid 3269 to -10
 setpriority(3 /*PRIO_THREAD*/, syscall(SYS_gettid), -1);
setting prio of pid 3270 tgid 3269 to -1
 setpriority(PRIO_PROCESS, syscall(SYS_gettid), -2);
setting prio of pid 3270 tgid 3269 to -2

Above you see how setpriority(PRIO_PROCESS) can set prio for all threads
or only for one.

  prio = getpriority(PRIO_PROCESS, tid);
PRIO_PROCESS: pid 3270 tgid 3269: niceval=22
PRIO_PROCESS: returning retval=22
  prio = getpriority(PRIO_PROCESS, pid);
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: pid 3270 tgid 3269: niceval=22
PRIO_PROCESS: pid 3271 tgid 3269: niceval=30
PRIO_PROCESS: pid 3272 tgid 3269: niceval=30
PRIO_PROCESS: pid 3273 tgid 3269: niceval=30
PRIO_PROCESS: returning retval=30

Same for getpriority.

The rest is analogous:

setting prio of pid 3271 tgid 3269 to -3
setting prio of pid 3271 tgid 3269 to -4
PRIO_PROCESS: pid 3271 tgid 3269: niceval=24
PRIO_PROCESS: returning retval=24
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: pid 3271 tgid 3269: niceval=24
PRIO_PROCESS: pid 3272 tgid 3269: niceval=30
PRIO_PROCESS: pid 3273 tgid 3269: niceval=30
PRIO_PROCESS: returning retval=30
setting prio of pid 3272 tgid 3269 to -5
setting prio of pid 3272 tgid 3269 to -6
PRIO_PROCESS: pid 3272 tgid 3269: niceval=26
PRIO_PROCESS: returning retval=26
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: pid 3272 tgid 3269: niceval=26
PRIO_PROCESS: pid 3273 tgid 3269: niceval=30
PRIO_PROCESS: returning retval=30
setting prio of pid 3273 tgid 3269 to -7
setting prio of pid 3273 tgid 3269 to -8
PRIO_PROCESS: pid 3273 tgid 3269: niceval=28
PRIO_PROCESS: returning retval=28
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: pid 3273 tgid 3269: niceval=28
PRIO_PROCESS: returning retval=30
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: returning retval=30
PRIO_PROCESS: pid 3269 tgid 3269: niceval=30
PRIO_PROCESS: returning retval=30

Patch with instrumentation is attached too.
--
vda



--=-NCfCbLjWwBz2/YpP80Vs
Content-Disposition: attachment; filename=prio_vda3.c
Content-Type: text/x-csrc; name=prio_vda3.c; charset=utf-8
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <memory.h>

#define THREAD_NUM 5

static void printprio(const char *pfx)
{
	int prio;
	pid_t tid = syscall(SYS_gettid);
	pid_t pid = getpid();
	prio = getpriority(PRIO_PROCESS, tid);
	printf("%sTID:%d getpriority:%d\n", pfx, tid, prio);
	prio = getpriority(PRIO_PROCESS, pid);
	printf("%sPID:%d getpriority:%d\n", pfx, pid, prio);
}

int threadno;

static void* threadfunc(void *dummy)
{
	sleep(1); /* wait for parent to setpriority */
	setpriority(3 /*PRIO_THREAD*/, syscall(SYS_gettid), -(++threadno));
	setpriority(PRIO_PROCESS, syscall(SYS_gettid), -(++threadno));
	printprio("THREAD CHILD: ");
	pthread_exit(0);
}

int main()
{
	pid_t pid = fork();
	if (pid) {
		/* parent */
		int status;
		printf("start test program\n");
		sleep(1); /* wait for threads to start in child */
		printf("setpriority(PRIO_PROCESS, %d, -10)\n", pid);
		if (setpriority(PRIO_PROCESS, pid, -10) < 0) {
			perror("setpriority PRIO_PROCESS");
			exit(1);
		}
		wait(&status);
	} else { 
		/* child */
		int i;
		pthread_t thread_id[THREAD_NUM];

		printprio("CHILD1: ");
		for (i = 1; i < THREAD_NUM; i++) {
			usleep(30*1000);
			pthread_create(&thread_id[i], NULL, &threadfunc, NULL);
		}

		usleep(30*1000);
		sleep(1); /* wait for parent to setpriority */
		printprio("CHILD2: ");

		for (i = 1; i < THREAD_NUM; i++) {
			pthread_join(thread_id[i], NULL);
			printf("Joined!\n");
		}
	}
	return 0;
}

--=-NCfCbLjWwBz2/YpP80Vs
Content-Disposition: attachment; filename=setprio_POSIX_instrumented.diff
Content-Type: text/x-patch; name=setprio_POSIX_instrumented.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

--- a/kernel/sys.c.orig	2008-09-01 12:50:22.000000000 +0200
+++ b/kernel/sys.c	2008-09-01 15:11:45.000000000 +0200
@@ -162,15 +162,22 @@
 			else
 				p = current;
 			if (p)
+{printk("setting prio of pid %d tgid %d to %d\n", p->pid, p->tgid, niceval);
 				error = set_one_prio(p, niceval, error);
+}
 			break;
 		case PRIO_PROCESS:
 			if (who)
 				pid = find_vpid(who);
-			else
+			else {
 				pid = task_pid(current);
+				who = current->pid;
+			}
 			do_each_pid_thread(pid, PIDTYPE_PID, p) {
-				error = set_one_prio(p, niceval, error);
+				if (who == p->pid || who == p->tgid) {
+printk("setting prio of pid %d tgid %d to %d\n", p->pid, p->tgid, niceval);
+					error = set_one_prio(p, niceval, error);
+				}
 			} while_each_pid_thread(pid, PIDTYPE_PID, p);
 			break;
 		case PRIO_PGRP:
@@ -231,18 +238,25 @@
 				niceval = 20 - task_nice(p);
 				if (niceval > retval)
 					retval = niceval;
+printk("PRIO_THREAD: pid %d tgid %d: niceval=%ld retval=%ld\n", p->pid, p->tgid, niceval, retval);
 			}
 			break;
 		case PRIO_PROCESS:
 			if (who)
 				pid = find_vpid(who);
-			else
+			else {
 				pid = task_pid(current);
+				who = current->pid;
+			}
 			do_each_pid_thread(pid, PIDTYPE_PID, p) {
-				niceval = 20 - task_nice(p);
-				if (niceval > retval)
-					retval = niceval;
+				if (who == p->pid || who == p->tgid) {
+					niceval = 20 - task_nice(p);
+					if (niceval > retval)
+						retval = niceval;
+printk("PRIO_PROCESS: pid %d tgid %d: niceval=%ld\n", p->pid, p->tgid, niceval);
+				}
 			} while_each_pid_thread(pid, PIDTYPE_PID, p);
+printk("PRIO_PROCESS: returning retval=%ld\n", retval);
 			break;
 		case PRIO_PGRP:
 			if (who)

--=-NCfCbLjWwBz2/YpP80Vs--

