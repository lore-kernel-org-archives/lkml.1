Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbYEGLmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbYEGLmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbYEGLlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:41:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57632 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977AbYEGLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:41:17 -0400
Message-ID: <4821955D.8070601@bull.net>
Date: Wed, 07 May 2008 13:41:17 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 0/9] Scalability requirements for sysv ipc - v3
References: <20080507113553.395937000@bull.net>
In-Reply-To: <20080507113553.395937000@bull.net>
Content-Type: multipart/mixed;
 boundary="------------000009000709070903080601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000009000709070903080601
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Nadia.Derbey@bull.net wrote:
> After scalability problems have been detected when using the sysV ipcs, I
> have proposed to use an RCU based implementation of the IDR api instead (see
> threads http://lkml.org/lkml/2008/4/11/212 and
> http://lkml.org/lkml/2008/4/29/295).
> 
> This resulted in many people asking to convert the idr API and make it
> rcu safe (because most of the code was duplicated and thus unmaintanable
> and unreviewable).
> 
> So here is a first attempt.
> 
> The important change wrt to the idr API itself is during idr removes:
> idr layers are freed after a grace period, instead of being moved to the
> free list.
> 
> The important change wrt to ipcs, is that idr_find() can now be called
> locklessly inside a rcu read critical section.
> 
> Here are the results I've got for the pmsg test sent by Manfred: 
> 
>    2.6.25-rc3-mm1   2.6.25-rc3-mm1+   2.6.25-mm1   Patched 2.6.25-mm1
> 1         1168441           1064021       876000               947488
> 2         1094264            921059      1549592              1730685
> 3         2082520           1738165      1694370              2324880
> 4         2079929           1695521       404553              2400408
> 5         2898758            406566       391283              3246580
> 6         2921417            261275       263249              3752148
> 7         3308761            126056       191742              4243142
> 8         3329456            100129       141722              4275780
> 
> 1st column: stock 2.6.25-rc3-mm1
> 2nd column: 2.6.25-rc3-mm1 + ipc patches (store ipcs into idrs)
> 3nd column: stock 2.6.25-mm1
> 4th column: 2.6.25-mm1 + this pacth series.
> 


You'll find in attachment the corresponding chart, and also the pmsg 
code (originally sent by Manfred).

Regards,
Nadia


--------------000009000709070903080601
Content-Type: application/force-download;
 name="results.pdf"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="results.pdf"

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
4gr34sJgD3VozLj3tMmksnNTUJ4xKoOyym+LzFSZIxK3pub4NcRrqqoYAo/a7oAMP4YwyMqA
tCi6iABLeysD0OsgQpxuEHiUAX5RYtvmu4F4SrSqRgb4TlcEBKjO/bCjItAhr4wg88AVOrYR
0NAogpJZ7JA9ip+Niawm20MefGNVAEEC4BGo+XKVe0/qX4JcS4VlbmRzdHJlYW0NCmVuZG9i
ag0KDQoyIDAgb2JqDQogIDE5MDENCmVuZG9iag0KDQo0IDAgb2JqDQo8PCAvVHlwZSAvUGFn
ZQ0KICAgL1BhcmVudCAzIDAgUg0KICAgL01lZGlhQm94IFsgMCAwIDU5NSA4NDIgXQ0KICAg
L0NvbnRlbnRzIDEgMCBSDQo+Pg0KZW5kb2JqDQoNCjUgMCBvYmoNCjw8IC9MZW5ndGggNiAw
IFINCiAgIC9GaWx0ZXIgL0ZsYXRlRGVjb2RlDQogICAvTGVuZ3RoMSAxNjA3Ng0KPj4NCnN0
cmVhbQ0KeJzdewt4VNXV6N5nnzPPTDIzyQRCJpOTFxAISUhEHj6YkAwQCElIAoKKZpKZPDTJ
jDMTIqI/D0siBQuoxBYRooJSpBSRYoJIUamoSGsL9KtX+1sVRWtE6o+1DcnOXXufM3mJj/vd
+3/3uzeHM9mP9V5rr7X2REOBZi+KQKsRQc7qRrd/35b1qxFCbyGErdXLQ/KMUX96BcZ/g7e3
xl/bePrrw+8hROBFG2obVtTMPvToQoTEOoRiQnVetydphpiI0Gi2f20dLDhpkxahuBiYp9Y1
hu7eapy2BebTYP5Ag6/avXTJvAqYH4f57Eb33f53pUUiQmN0MJeb3I3essc7ymE+HqHEMX5f
MLQJZfYjNL2A7fsDXn/NJfEdmHsQkkAGhOFhPxEw1LC5QERJo9XpDcYIU2SU2WKNjrHFjhod
NybenuBIlJPQ/+c/eArqRKfgeRntRdvx0zCrgeW7YKVDOIjWoWZYeRWfwuuFSbD2NLqEzgBk
GzpF9ooIz0O5sIrQO5KALuMKdAhoTMcxeLpWIyKxWDwklomd4gXxNJoqBsXTYqUYxLnkSWmx
9DS808nvBCt6AyWiTvw+CqIj5DOSS46KBWIkep+cJnvRx8AF/A08NqFdaCXIEoN9aJWwUiiD
lZPSabQNHh/sn8Y78BmQ7gi+H51DPyeiMBftwOdAr1Pon+h+UiGsgrjMFWpA/pNA6zTgb0NB
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
aFKYYJIKzWSuicyhZHY7cbWTAkryhUlSfg+Z9SLJm0+clMyk5MYbrNKNMeSG66OkG6zk+utM
0vXO/ihynYnMoGQ6JdOmxkjTesjUa83S1Bhy7RSjdK2ZTDGSaxwk10RyJhulHEomG0l2llHK
NpEsI8mcpJcyzWSSnmTkkIkT0qSJHjIh3SpNSCPpVjJ+XJo0Po+MSyNj04zS2CiSZiSplKRQ
khxFkkDPJCuRPSSxhzhABYeHJJiIHSxopyS+h4yZReJgEkfJaA8ZBZYaRUksIMXGERslMZRE
U2IFACslFtDVMouY7yNRHhJJiSkiVjJREgHQEbHESInBTPSU6ABMR4k2hmg8RIRNESLARmCV
UCLAXJhEsJkgSnAn9qx7EE/8f+EH/d8W4Ht/Ev4nmQHR7g0KZW5kc3RyZWFtDQplbmRvYmoN
Cg0KNiAwIG9iag0KOTEwMA0KZW5kb2JqDQoNCjcgMCBvYmoNCjw8IC9UeXBlIC9Gb250RGVz
Y3JpcHRvcg0KICAgL0ZvbnROYW1lIC9CQUFBQUErQml0c3RyZWFtVmVyYVNhbnMtUm9tYW4N
CiAgIC9GbGFncyA0DQogICAvRm9udEJCb3ggWyAtMTgzIC0yMzUgMTI4NiA5MjggXQ0KICAg
L0l0YWxpY0FuZ2xlIDANCiAgIC9Bc2NlbnQgOTI4DQogICAvRGVzY2VudCAtMjM1DQogICAv
Q2FwSGVpZ2h0IDkyOA0KICAgL1N0ZW1WIDgwDQogICAvRm9udEZpbGUyIDUgMCBSDQo+Pg0K
ZW5kb2JqDQoNCjggMCBvYmoNCjw8IC9MZW5ndGggMzc3DQogICAvRmlsdGVyIC9GbGF0ZURl
Y29kZSA+Pg0Kc3RyZWFtDQp4nF2Sy26CQBSG9yS8wyztwsDMyKgJIbGoiYteUtoHQDhYkjKQ
ARe8feH8appuJN+cy5zPOUF62p9sPYjg3bVFRoOoals66turK0ic6VJb35NKlHUx3JE/RZN3
vhdM9dnYD9ScbNWKOPY9IYKPKaEf3CgWu7I90xMfvrmSXG0vYvGVZjjKrl33Qw3ZQYS+lySi
pGru+ZJ3r3lDIuDy5amcMuphXE6Ff1I+x46EwoHEbEVbUt/lBbncXsj34jBMRHw8Jr5Htvwf
1RpV56r4zt2cLafsMFyHyQyKwewZNCKaYYXImiFiUKgxSFMMa6RFDBtEAFtEUoYdIiuGZ4YI
3VKkSYY9gwYcALjniAkOM8gQEcMAH82XSvgo9pHwMewj4aMB8DEbBvgYnk3CRyMCH40IfDRP
LeGj+d+R8NFbBviscA98IswGnwjd4GPYR8HHcAMFH3N7z/u7zU/L2/hYnOLq3LQzvLS8K/OW
1JYei921Hdfdfn4B8Ze8B2VuZHN0cmVhbQ0KZW5kb2JqDQoNCjkgMCBvYmoNCjw8IC9UeXBl
IC9Gb250DQogICAvU3VidHlwZSAvVHJ1ZVR5cGUNCiAgIC9CYXNlRm9udCAvQkFBQUFBK0Jp
dHN0cmVhbVZlcmFTYW5zLVJvbWFuDQogICAvRmlyc3RDaGFyIDANCiAgIC9MYXN0Q2hhciAz
Mw0KICAgL1dpZHRocyBbIDYwMCA2MzQgOTc0IDUyMCA2MzQgMzE3IDQxMSA2MTUNCiAgICAg
NjMzIDI3NyAzOTIgNjAzIDYxMiA2MzYgNjM2IDMxNw0KICAgICA2MzYgNjM2IDM2MCA1NDkg
NjM2IDYzMyA2MzQgNjM2DQogICAgIDYzNiA2MzYgNjM2IDYzNiA2OTggNzMxIDYxMCA2MzMN
CiAgICAgMjc3IDYxMSBdDQogICAvRm9udERlc2NyaXB0b3IgNyAwIFINCiAgIC9Ub1VuaWNv
ZGUgOCAwIFINCj4+DQplbmRvYmoNCg0KMTAgMCBvYmoNCjw8IC9GMSA5IDAgUg0KICAgPj4N
CmVuZG9iag0KDQoxMSAwIG9iag0KPDwNCiAgIC9Gb250IDEwIDAgUg0KICAgL1Byb2NTZXQg
WyAvUERGIF0NCj4+DQplbmRvYmoNCg0KMyAwIG9iag0KPDwgL1R5cGUgL1BhZ2VzDQogICAv
UmVzb3VyY2VzIDExIDAgUg0KICAgL01lZGlhQm94IFsgMCAwIDU5NSA4NDIgXQ0KICAgL0tp
ZHMgWyA0IDAgUg0KICAgICAgICAgICBdDQogICAvQ291bnQgMQ0KPj4NCmVuZG9iag0KDQox
MiAwIG9iag0KPDwgL1R5cGUgL0NhdGFsb2cNCiAgIC9QYWdlcyAzIDAgUg0KPj4NCmVuZG9i
ag0KDQoxMyAwIG9iag0KPDwgL1Byb2R1Y2VyIDxGRUZGMDA0RjAwNzAwMDY1MDA2RTAwNEYw
MDY2MDA2NjAwNjkwMDYzMDA2NTAwMkUwMDZGMDA3MjAwNjcwMDIwMDAzMTAwMkUwMDMxMDAy
RTAwMzA+DQovQ3JlYXRpb25EYXRlIChEOjIwMDgwNTA3MTA1MjExKzAyJzAwJykNCj4+DQpl
bmRvYmoNCg0KeHJlZg0KMCAxNA0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDE3IDAw
MDAwIG4NCjAwMDAwMDIwMDMgMDAwMDAgbg0KMDAwMDAxMjU1MiAwMDAwMCBuDQowMDAwMDAy
MDMwIDAwMDAwIG4NCjAwMDAwMDIxMzcgMDAwMDAgbg0KMDAwMDAxMTM0MyAwMDAwMCBuDQow
MDAwMDExMzY4IDAwMDAwIG4NCjAwMDAwMTE2MjAgMDAwMDAgbg0KMDAwMDAxMjA3OSAwMDAw
MCBuDQowMDAwMDEyNDQ0IDAwMDAwIG4NCjAwMDAwMTI0ODUgMDAwMDAgbg0KMDAwMDAxMjY4
OSAwMDAwMCBuDQowMDAwMDEyNzQ5IDAwMDAwIG4NCnRyYWlsZXINCjw8IC9TaXplIDE0DQog
ICAvUm9vdCAxMiAwIFINCiAgIC9JbmZvIDEzIDAgUg0KPj4NCnN0YXJ0eHJlZg0KMTI5MTUN
CiUlRU9GDQo=
--------------000009000709070903080601
Content-Type: text/x-c++;
 name="pmsg.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pmsg.cpp"

/*
 * pmsg.cpp, parallel sysv msg pingpong
 *
 * Copyright (C) 1999, 2001, 2005, 2008 by Manfred Spraul.
 *	All rights reserved except the rights granted by the GPL.
 *
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL) version 2 or later.
 * $Header$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <pthread.h>

//////////////////////////////////////////////////////////////////////////////

static enum {
	WAITING,
	RUNNING,
	STOPPED,
} volatile g_state = WAITING;

unsigned long long *g_results;
int *g_svmsg_ids;
pthread_t *g_threads;

struct taskinfo {
	int svmsg_id;
	int threadid;
	int cpuid;
	int sender;
};

#define DATASIZE	8

void* worker_thread(void *arg)
{
	struct taskinfo *ti = (struct taskinfo*)arg;
	unsigned long long rounds;
	int ret;
	struct {
		long mtype;
		char buffer[DATASIZE];
	} mbuf;

	{
		cpu_set_t cpus;
		CPU_ZERO(&cpus);
		CPU_SET(ti->cpuid, &cpus);

		ret = pthread_setaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_setaffinity_np failed for thread %d with errno %d.\n",
					ti->threadid, errno);
		}

		ret = pthread_getaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_getaffinity_np() failed for thread %d with errno %d.\n",
					ti->threadid, errno);
			fflush(stdout);
		} else {
			printf("thread %d: sysvmsg %8d type %d bound to %04lxh\n",ti->threadid,
					ti->svmsg_id, ti->sender, cpus.__bits[0]);
		}
		fflush(stdout);
	}

	rounds = 0;
	while(g_state == WAITING) {
#ifdef __i386__
		__asm__ __volatile__("pause": : :"memory");
#endif
	}

	if (ti->sender) {
		mbuf.mtype = ti->sender+1;
		ret = msgsnd(ti->svmsg_id, &mbuf, DATASIZE, 0);
		if (ret != 0) {
			printf("Initial send failed, errno %d.\n", errno);
			exit(1);
		}
	}
	while(g_state == RUNNING) {
		int target = 1+!ti->sender;

		ret = msgrcv(ti->svmsg_id, &mbuf, DATASIZE, target, 0);
		if (ret != DATASIZE) {
			if (errno == EIDRM)
				break;
			printf("Error on msgrcv, got %d, errno %d.\n", ret, errno);
			exit(1);
		}
		mbuf.mtype = ti->sender+1;
		ret = msgsnd(ti->svmsg_id, &mbuf, DATASIZE, 0);
		if (ret != 0) {
			if (errno == EIDRM)
				break;
			printf("send failed, errno %d.\n", errno);
			exit(1);
		}
		rounds++;
	}
	/* store result */
	g_results[ti->threadid] = rounds;

	pthread_exit(0);
	return NULL;
}

void init_threads(int cpu, int cpus)
{
	int ret;
	struct taskinfo *ti1, *ti2;

	ti1 = new (struct taskinfo);
	ti2 = new (struct taskinfo);
	if (!ti1 || !ti2) {
		printf("Could not allocate task info\n");
		exit(1);
	}

	g_svmsg_ids[cpu] = msgget(IPC_PRIVATE,0777|IPC_CREAT);
	if(g_svmsg_ids[cpu] == -1) {
		printf(" message queue create failed.\n");
		exit(1);
	}

	g_results[cpu] = 0;
	g_results[cpu+cpus] = 0;

	ti1->svmsg_id = g_svmsg_ids[cpu];
	ti1->threadid = cpu;
	ti1->cpuid = cpu;
	ti1->sender = 1;
	ti2->svmsg_id = g_svmsg_ids[cpu];
	ti2->threadid = cpu+cpus;
	ti2->cpuid = cpu;
	ti2->sender = 0;

	ret = pthread_create(&g_threads[ti1->threadid], NULL, worker_thread, ti1);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
	ret = pthread_create(&g_threads[ti2->threadid], NULL, worker_thread, ti2);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

int main(int argc, char **argv)
{
	int queues, timeout;
	unsigned long long totals;
	int i;

	printf("pmsg [nr queues] [timeout]\n");
	if (argc != 3) {
		printf(" Invalid parameters.\n");
		return 0;
	}
	queues = atoi(argv[1]);
	timeout = atoi(argv[2]);
	printf("Using %d queues/cpus (%d threads) for %d seconds.\n",
			queues, 2*queues, timeout);

	g_results = new unsigned long long[2*queues];
	g_svmsg_ids = new int[queues];
	g_threads = new pthread_t[2*queues];
	for (i=0;i<queues;i++) {
		init_threads(i, queues);
	}

	sleep(1);
	g_state = RUNNING;
	sleep(timeout);
	g_state = STOPPED;
	sleep(1);
	for (i=0;i<queues;i++) {
		int res;
		res = msgctl(g_svmsg_ids[i],IPC_RMID,NULL);
		if (res < 0) {
			printf("msgctl(IPC_RMID) failed for %d, errno%d.\n",
				g_svmsg_ids[i], errno);
		}
	}
	for (i=0;i<2*queues;i++)
		pthread_join(g_threads[i], NULL);

	printf("Result matrix:\n");
	totals = 0;
	for (i=0;i<queues;i++) {
		printf("  Thread %3d: %8lld     %3d: %8lld\n",
				i, g_results[i], i+queues, g_results[i+queues]);
		totals += g_results[i] + g_results[i+queues];
	}
	printf("Total: %lld\n", totals);
}

--------------000009000709070903080601--
