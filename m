Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbXH3Huy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbXH3Huy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbXH3Hup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:50:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbXH3Huo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:50:44 -0400
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2.6.21] Return available first timeslice to the creator, not parent
From: Vitaly Mayatskikh <vmayatsk@redhat.com>
X-URL: http://people.redhat.com/vmayatsk
Date: Thu, 30 Aug 2007 09:50:30 +0200
Message-ID: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


Short-living process returns its timeslice to the parent, this affects process that creates a lot of such short-living threads, because its not a parent for new threads. Patch fixes this issue and doesn't break kabi as does the patch from reporter: http://lkml.org/lkml/2007/4/7/21

An example and script for systemtap were modified a bit. Patch was tested on 2.6.21 with results:

Pass 1: parsed user script and 54 library script(s) in 330usr/10sys/340real ms.
Pass 2: analyzed script: 3 probe(s), 10 function(s), 0 embed(s), 10 global(s) in 540usr/890sys/1445real ms.
Pass 3: translated to C into "/tmp/stapg9EJ30/stap_09f64923e2e59e40ae9680eee1ee0ac9_7206.c" in 10usr/0sys/5real ms.
Pass 4: compiled C into "stap_09f64923e2e59e40ae9680eee1ee0ac9_7206.ko" in 2880usr/250sys/3124real ms.
Pass 5: starting run.
sched_exit/enter:  pid = 16625, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16625, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16626, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16626, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16627, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16627, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16628, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16628, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16629, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16629, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16637, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16637, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16638, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16638, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16639, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16639, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16640, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16640, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16641, tgid = 16623, ppid = 3761, creator = 16624, avail. timeslice = 6, creator's timeslice = 5
sched_exit/return: pid = 16641, tgid = 16623, ppid = 3761, creator = 16624, creator's adjusted timeslice = 11
sched_exit/enter:  pid = 16624, tgid = 16623, ppid = 3761, creator = 16623, avail. timeslice = 11, creator's timeslice = 10
sched_exit/return: pid = 16624, tgid = 16623, ppid = 3761, creator = 16623, creator's adjusted timeslice = 21
sched_exit/enter:  pid = 16623, tgid = 16623, ppid = 3761, creator = 3761, avail. timeslice = 21, creator's timeslice = 21
sched_exit/return: pid = 16623, tgid = 16623, ppid = 3761, creator = 3761, creator's adjusted timeslice = 42
Pass 5: run completed in 40usr/150sys/4266real ms.


--=-=-=
Content-Disposition: inline; filename=2.6.21-timeslice.patch
Content-Description: proposed patch

diff -up -bB ./include/linux/sched.h.orig ./include/linux/sched.h
--- ./include/linux/sched.h.orig	2007-08-21 09:20:22.000000000 +0200
+++ ./include/linux/sched.h	2007-08-27 10:14:06.000000000 +0200
@@ -827,7 +827,9 @@ struct task_struct {
 
 	unsigned long policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice, first_time_slice;
+	unsigned int time_slice;
+	/* Pid of creator */
+	unsigned int cpid;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
diff -up -bB ./kernel/sched.c.orig ./kernel/sched.c
--- ./kernel/sched.c.orig	2007-08-21 09:20:22.000000000 +0200
+++ ./kernel/sched.c	2007-08-27 10:18:44.000000000 +0200
@@ -1626,9 +1626,9 @@ void fastcall sched_fork(struct task_str
 	p->time_slice = (current->time_slice + 1) >> 1;
 	/*
 	 * The remainder of the first timeslice might be recovered by
-	 * the parent if the child exits early enough.
+	 * the creator (not parent!) if the child exits early enough.
 	 */
-	p->first_time_slice = 1;
+	p->cpid = current->pid;
 	current->time_slice >>= 1;
 	p->timestamp = sched_clock();
 	if (unlikely(!current->time_slice)) {
@@ -1728,33 +1728,46 @@ void fastcall wake_up_new_task(struct ta
 
 /*
  * Potentially available exiting-child timeslices are
- * retrieved here - this way the parent does not get
+ * retrieved here - this way the creator does not get
  * penalized for creating too many threads.
  *
  * (this cannot be used to 'generate' timeslices
  * artificially, because any timeslice recovered here
- * was given away by the parent in the first place.)
+ * was given away by the creator in the first place.)
  */
 void fastcall sched_exit(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-
+	struct task_struct* creator = NULL;
 	/*
 	 * If the child was a (relative-) CPU hog then decrease
-	 * the sleep_avg of the parent as well.
+	 * the sleep_avg of the creator as well.
 	 */
-	rq = task_rq_lock(p->parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
-		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > task_timeslice(p)))
-			p->parent->time_slice = task_timeslice(p);
+	if (p->cpid) {
+		struct pid *pid = find_get_pid((pid_t)p->cpid);
+		if (pid) {
+			creator = get_pid_task(pid, PIDTYPE_PID);
+			put_pid(pid);
 	}
-	if (p->sleep_avg < p->parent->sleep_avg)
-		p->parent->sleep_avg = p->parent->sleep_avg /
+
+		if (creator) {
+			if (task_cpu(p) == task_cpu(creator)) {
+				rq = task_rq_lock(creator, &flags);
+
+				creator->time_slice += p->time_slice;
+				if (unlikely(creator->time_slice > task_timeslice(p)))
+					creator->time_slice = task_timeslice(p);
+
+				if (p->sleep_avg < creator->sleep_avg)
+					creator->sleep_avg = creator->sleep_avg /
 		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
 		(EXIT_WEIGHT + 1);
 	task_rq_unlock(rq, &flags);
+			}
+			put_task_struct(creator);
+		}
+	}
 }
 
 /**
@@ -3153,7 +3166,7 @@ static void task_running_tick(struct rq 
 		 */
 		if ((p->policy == SCHED_RR) && !--p->time_slice) {
 			p->time_slice = task_timeslice(p);
-			p->first_time_slice = 0;
+			p->cpid = 0;
 			set_tsk_need_resched(p);
 
 			/* put it at the end of the queue: */
@@ -3166,7 +3179,7 @@ static void task_running_tick(struct rq 
 		set_tsk_need_resched(p);
 		p->prio = effective_prio(p);
 		p->time_slice = task_timeslice(p);
-		p->first_time_slice = 0;
+		p->cpid = 0;
 
 		if (!rq->expired_timestamp)
 			rq->expired_timestamp = jiffies;

--=-=-=
Content-Disposition: inline; filename=satthread.c
Content-Description: test app sources

///////////////////////////////////////////////////////////////////////////////
/// satthread.c ///////////////////////////////////////////////////////////////
/*
 * satthread - Create child thread and join it several times. Each child thread
 *             does nothing and exits immediately.
 *
 * Copyright (C) 2007 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
 *
 * This software may be used and distributed according to the terms
 * of the GNU General Public License, incorporated herein by reference.
 */
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define NTHREAD 10

static void *thread_fn(void *arg)
{
	return NULL;
}

static void *creator(void* arg)
{
	int i;
	pthread_t t;
	for (i = 0; i < NTHREAD; i++) {
		if (pthread_create(&t, NULL, thread_fn, NULL)) {
			fprintf(stderr, "pthread_create(%d) failed\n", i);
			exit(EXIT_FAILURE);
		}
		usleep(100 * 1000);
		pthread_join(t, NULL);
	}
}

int
main(int argc, char **argv)
{
	int i;
	pthread_t t;
	if (pthread_create(&t, NULL, creator, NULL)) {
		fprintf(stderr, "pthread_create (creator) failed\n");
		exit(EXIT_FAILURE);
	}
	pthread_join(t, NULL);
	exit(EXIT_SUCCESS);
}

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Disposition: inline; filename=fork_exit21.stp
Content-Transfer-Encoding: quoted-printable
Content-Description: test script for stap

///////////////////////////////////////////////////////////////////////////=
////
/// fork_exit.stp /////////////////////////////////////////////////////////=
////
/*
 * fork_exit.stp - Overlooks sched_fork()/exit_exit() for satprocess/satthr=
ead
 *                 and prints some information
 *
 * Copyright (C) 2007 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
 * Copyright (C) 2007 Vitaly Mayatskikh <vmayatsk@redhat.com>
 *
 * This software may be used and distributed according to the terms
 * of the GNU General Public License, incorporated herein by reference.
 */
=20
function is_my_testpro(comm)
{
	if (comm =3D=3D "satthread" || comm =3D=3D "satprocess" || comm =3D=3D "th=
read-stress")
		return 1
	else
		return 0
}

function get_creators_timeslice:long(cpid:long)
%{
    struct task_struct* creator =3D 0;

    if (THIS->cpid)
	creator =3D find_task_by_pid_type(PIDTYPE_PID, THIS->cpid);
    if (creator)
	THIS->__retvalue =3D creator->time_slice;
    else
	THIS->__retvalue =3D 0;
%}

probe kernel.function("sched_exit")
{
	if (is_my_testpro(kernel_string($p->comm)))
		printf("sched_exit/enter:  pid =3D %d, tgid =3D %d, ppid =3D %d, creator =
=3D %d, avail. timeslice =3D %d, creator's timeslice =3D %d\n",
		    $p->pid, $p->tgid, $p->parent->pid, $p->cpid, $p->time_slice, get_cre=
ators_timeslice($p->cpid));
}

probe kernel.function("sched_exit").return
{
	if (is_my_testpro(kernel_string($p->comm)))
		printf("sched_exit/return: pid =3D %d, tgid =3D %d, ppid =3D %d, creator =
=3D %d, creator's adjusted timeslice =3D %d\n",
		    $p->pid, $p->tgid, $p->parent->pid, $p->cpid, get_creators_timeslice(=
$p->cpid)
		);
}

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG1nbQH+2WUUui6PsRAjP2AJ9GPAEcsVq3pNVwhuAVYttFPd9n6QCfXVKd
U4jiyOobRaIvQujN34J0oPQ=
=d8Ke
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=



-- 
Vitaly Mayatskikh <vmayatsk@redhat.com>

Kernel development
Red Hat Czech, Brno

Phone: +420 532 294 111
IRC: vitaly on #kernel, #brno
GPG: 0x4BA2E8FB

--=-=-=--
