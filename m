Return-Path: <linux-kernel-owner+w=401wt.eu-S935050AbZJOSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935050AbZJOSBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbZJOSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:01:48 -0400
Received: from smail6.alcatel.fr ([64.208.49.42]:59462 "EHLO smail6.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZJOSBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:01:46 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2009 14:01:46 EDT
Message-ID: <4AD76126.1000408@alcatel-lucent.de>
Date: Thu, 15 Oct 2009 19:51:34 +0200
From: Joerg Abraham <Joerg.Abraham@alcatel-lucent.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.31.4-rt14 posix message queues problem
Content-Type: multipart/mixed;
	boundary="------------060601000705060302040908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060601000705060302040908
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

During some performance measurement I stumbled over unexpected bad results for 
a posix message queue test case. Which is not surprising since the kernel log 
shows a "BUG: scheduling while atomic:" on every measurement trigger.

Attached is the kernel log for an embedded 8572ds powerpc system and a 
condensed user space test appli. The test appli uses 2 processes (mq_server 
and mq_client) and pingpongs some messages via posix message queues. Please 
see the c-file header for details (the appli itself makes not much sense but 
shows the problem).

./mq_server
./mq_client # just crashes during run

The problem does _not_ occur on kernels 2.6.29.6-rt24, 2.6.29.6 vanilla and 
2.6.31.4 vanilla. The problem does _also_ show up on an embedded x86_64 system 
and a full featured fc11 x86_64 system running a 2.6.31.4-rt14 based kernel, 
so I dont think it's arch dependent.

Can anybody reproduce the crash ???

If you need more info's please let me know.

[And if I'm doing stupid things just forgive me]

Thanx

Joerg


--------------060601000705060302040908
Content-Type: text/plain; name="2.6.31.4-rt14_posix_mq.crash"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="2.6.31.4-rt14_posix_mq.crash"

[    1.106260] NET: Registered protocol family 17
[    1.110896] RPC: Registered udp transport module.
[    1.115600] RPC: Registered tcp transport module.
[    1.120324] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    1.127113] All bugs added by David S. Miller <davem@redhat.com>
[    1.133717] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.140006] Freeing unused kernel memory: 180k init
[    6.931612] PHY: mdio@ffe24520:00 - Link is Up - 1000/Full
[  394.113565] BUG: scheduling while atomic: mq_client/0x00000001/1039, CPU#1
[  394.113572] Modules linked in:
[  394.113575] Call Trace:
[  394.113586] [ee8bddb0] [c00074d8] show_stack+0x4c/0x16c (unreliable)
[  394.113596] [ee8bdde0] [c0037918] __schedule_bug+0x84/0x88
[  394.113606] [ee8bddf0] [c02f4828] __schedule+0x338/0x778
[  394.113611] [ee8bde60] [c02f4f14] schedule+0x20/0x44
[  394.113617] [ee8bde70] [c02f520c] schedule_timeout+0x1c4/0x204
[  394.113629] [ee8bdec0] [c0170b84] wq_sleep+0xb8/0x1a0
[  394.113635] [ee8bdee0] [c0170d34] sys_mq_timedreceive+0xc8/0x388
[  394.113644] [ee8bdf40] [c0010428] ret_from_syscall+0x0/0x3c
[  394.113692] BUG: scheduling while atomic: mq_server/0x00000001/1038, CPU#1
[  394.113696] Modules linked in:
[  394.113699] Call Trace:
[  394.113704] [ee8b9db0] [c00074d8] show_stack+0x4c/0x16c (unreliable)
[  394.113711] [ee8b9de0] [c0037918] __schedule_bug+0x84/0x88
[  394.113717] [ee8b9df0] [c02f4828] __schedule+0x338/0x778
[  394.113723] [ee8b9e60] [c02f4f14] schedule+0x20/0x44
[  394.113728] [ee8b9e70] [c02f520c] schedule_timeout+0x1c4/0x204
[  394.113735] [ee8b9ec0] [c0170b84] wq_sleep+0xb8/0x1a0
[  394.113741] [ee8b9ee0] [c0170d34] sys_mq_timedreceive+0xc8/0x388
[  394.113747] [ee8b9f40] [c0010428] ret_from_syscall+0x0/0x3c
[  394.113758] Page fault in user mode with in_atomic() = 1 mm = eee98c00
[  394.113762] NIP = fec2d98  MSR = 202d000
[  394.113766] Oops: Weird page fault, sig: 11 [#1]
[  394.118382] PREEMPT SMP NR_CPUS=2 MPC8572 DS
[  394.122657] Modules linked in:
[  394.125710] NIP: 0fec2d98 LR: 0fec5278 CTR: 0fec51d8
[  394.130673] REGS: ee8bdf50 TRAP: 0301   Not tainted  (2.6.31.4-rt14-chja)
[  394.137461] MSR: 0202d000 <EE,PR,VEC,ME,CE>  CR: 44000422  XER: 20000000
[  394.144197] DEAR: 0ff96df8, ESR: 00000000
[  394.148203] TASK = eee48050[1039] 'mq_client' THREAD: ee8bc000 CPU: 1
[  394.154473] GPR00: 00000000 bff7fd50 48027cb0 bff8025c 0000000a bff8025c 0ff97010 00020cd9 
[  394.162866] GPR08: 00000001 00000001 00000001 00000064 0ff96df4 
[  394.169076] NIP [0fec2d98] 0xfec2d98
[  394.172647] LR [0fec5278] 0xfec5278
[  394.176130] Call Trace:
[  394.178583] ---[ end trace 5ca40653fb3fed3b ]---
[  394.183199] note: mq_client[1039] exited with preempt_count 1
[  394.189022] BUG: scheduling while atomic: mq_client/0x10000001/1039, CPU#1
[  394.195897] Modules linked in:
[  394.198950] Call Trace:
[  394.201394] [ee8bdd30] [c00074d8] show_stack+0x4c/0x16c (unreliable)
[  394.207758] [ee8bdd60] [c0037918] __schedule_bug+0x84/0x88
[  394.213250] [ee8bdd70] [c02f4828] __schedule+0x338/0x778
[  394.218567] [ee8bdde0] [c0039f84] __cond_resched+0x2c/0x50
[  394.224057] [ee8bddf0] [c02f4dbc] _cond_resched+0x40/0x54
[  394.229463] [ee8bde00] [c003fd00] put_files_struct+0xf8/0x110
[  394.235214] [ee8bde20] [c00419f8] do_exit+0x540/0x654
[  394.240269] [ee8bde70] [c000d98c] kernel_bad_stack+0x0/0x50
[  394.245850] [ee8bde90] [c001422c] do_page_fault+0x30c/0x4e8
[  394.251427] [ee8bdf40] [c0010868] handle_page_fault+0xc/0x80


--------------060601000705060302040908
Content-Type: text/plain; name="mq.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="mq.c"

/*
 * =====================================================================================
 *
 *       Filename:  mq.c
 *
 *    Description:  posix message test case
 *
 *    compile server:
 *        gcc -DMQ_SERVER -g -O2 -o mq_server mq.c -lrt
 *
 *    compile client:
 *        gcc -DMQ_CLIENT -g -O2 -o mq_client mq.c -lrt
 *
 * =====================================================================================
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <linux/unistd.h>
#include <time.h>
#include <malloc.h>
#include <mqueue.h>
#define _GNU_SOURCE
#include <sched.h>

#define MQ_SERVER_SIZE             (64)
#define MQ_SERVER_PATH             "/server_mq.1234"
#define MQ_SERVER_RES_PATH         "/server_mq_res.1234"

typedef struct mq_server_s
{
    unsigned long long int send_stamp;
    unsigned long long int rcvd_stamp;
    unsigned int cmd;
    unsigned int unused0;
    unsigned long long int unused1;
} mq_server_t;

typedef enum mq_cmd_s
{
    MQ_CMD_NOTHING = 0,
    MQ_CMD_GET_TS,
    MQ_CMD_EXIT
} mq_cmd_t;


static unsigned long long int get_current_timestamp(void)
{
    struct timespec ts;
	
    clock_gettime(CLOCK_MONOTONIC, &ts);

    return(((unsigned long long)ts.tv_sec) * 1000000000ULL + ((unsigned long long)ts.tv_nsec));
}

static int priority = 10; /* for FIFO scheduling class */


#if defined(MQ_SERVER)
/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  mq_server 
 *  Description:  creates 2 posix message queue, waits for msgs on one of them
 *                executes what is received, sends back the result via the other mq
 * =====================================================================================
 */
int main(int argc, char **argv)
{
    mqd_t mq_fd, mq_res_fd;
    struct mq_attr mq_attributes;
    mq_server_t mq_msg;
    int len;
    struct sched_param schedp;
    unsigned int mq_msg_prio = 1;
    /* int policy = SCHED_FIFO; */

    if (geteuid())
    {
	fprintf(stderr, "you should be root\n");
	exit(-1);
    }

    /* the server has higher prio */
    priority++;

    /* create 2 posix message queues */
    mq_attributes.mq_flags = 0;
    mq_attributes.mq_maxmsg = MQ_SERVER_SIZE;
    mq_attributes.mq_msgsize = sizeof(mq_server_t);
    mq_attributes.mq_curmsgs = 0;

    mq_fd = mq_open(MQ_SERVER_PATH, O_RDWR | O_CREAT,  S_IWUSR | S_IRUSR, &mq_attributes);
    mq_res_fd = mq_open(MQ_SERVER_RES_PATH, O_RDWR | O_CREAT,  S_IWUSR | S_IRUSR, &mq_attributes);

    memset(&schedp, 0, sizeof(schedp));
    /*
     * schedp.sched_priority = priority;
     * sched_setscheduler(0, policy, &schedp);	
     */
    
    fprintf(stderr, "mq_server started (pid: %d prio: %d)\n", getpid(), schedp.sched_priority);
    
    while(1)
    {
	len = mq_receive(mq_fd, (char *) &mq_msg, sizeof(mq_msg), &mq_msg_prio);
	    
	if(len == sizeof(mq_msg))
	{
	    switch(mq_msg.cmd)
	    {
		case MQ_CMD_NOTHING:
		    break;
		case MQ_CMD_GET_TS:
		    mq_msg.rcvd_stamp = get_current_timestamp();
		    /* send with received  prio */
		    mq_send(mq_res_fd, (char *) &mq_msg, sizeof(mq_msg), mq_msg_prio);
		    /* printf("got ts req send: 0x%016llx now: 0x%016llx \n", mq_msg.send_stamp, now ); */
		    break;
		case MQ_CMD_EXIT:
		    goto OUT;
		default:
		    break;
	    }
	}
    }

OUT:
    /* let the client finish */
    sleep(1);

    fprintf(stderr, "mq_server exiting\n");

    mq_close(mq_fd);
    mq_unlink(MQ_SERVER_PATH);
    mq_close(mq_res_fd);
    mq_unlink(MQ_SERVER_RES_PATH);

    return 0;
}


#elif defined(MQ_CLIENT)

static int timeout = 1000000; /* usec;  1 sec as default */

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  mq_client
 *  Description:  opens 2 posix message queue, send out jobs on one mq
 *                collects the result via the other mq and prints the result
 * =====================================================================================
 */
int main(int argc, char **argv)
{
    int i, len;
    mqd_t mq_fd, mq_res_fd;
    struct mq_attr mq_attributes;
    unsigned int mq_msg_prio = 1;
    mq_server_t mq_msg;
    struct sched_param schedp;
    /* int policy = SCHED_FIFO; */
    struct timespec ts_wait;

    if (geteuid())
    {
	fprintf(stderr, "you should be root\n");
	exit(-1);
    }

    ts_wait.tv_sec  =  timeout / 1000000;
    ts_wait.tv_nsec = (timeout % 1000000) * 1000;

    fprintf(stderr, "wait time: %ld seconds %ld nsec\n",  ts_wait.tv_sec,  ts_wait.tv_nsec);

    mq_fd = mq_open(MQ_SERVER_PATH, O_RDWR,  S_IWUSR | S_IRUSR, &mq_attributes);
    mq_res_fd = mq_open(MQ_SERVER_RES_PATH, O_RDWR,  S_IWUSR | S_IRUSR, &mq_attributes);
    
    memset(&schedp, 0, sizeof(schedp));
    /*
     * schedp.sched_priority = priority;
     * sched_setscheduler(0, policy, &schedp);	
     */

    fprintf(stderr, "mq_test started (pid: %d prio: %d)\n", getpid(), schedp.sched_priority);

    for(i = 0; i < 3; i++)
    {
	nanosleep(&ts_wait, NULL);
	/* sleep(1); */

	/* query ts service from server */
	mq_msg.cmd = MQ_CMD_GET_TS;
	mq_msg.send_stamp = get_current_timestamp();
	mq_send(mq_fd, (char *) &mq_msg, sizeof(mq_msg), mq_msg_prio);

	/* got response */
	len = mq_receive(mq_res_fd, (char *) &mq_msg, sizeof(mq_msg), &mq_msg_prio);

	if (len == sizeof(mq_msg))
	{
	    if(mq_msg.cmd == MQ_CMD_GET_TS)
	    {
		fprintf(stderr, "measured mq latency %lld nsec (i: %d)\n",
			mq_msg.rcvd_stamp - mq_msg.send_stamp, i);
	    }
	}
    } /* while (true) */

    fprintf(stderr, "measure loop exited\n");

    /* shut down server */
    mq_msg.cmd = MQ_CMD_EXIT;
    mq_send(mq_fd, (char *) &mq_msg, sizeof(mq_msg), mq_msg_prio);

    mq_close(mq_res_fd);
    mq_close(mq_fd);

    return 0;
}
#else
#error "MQ_SERVER or MQ_CLIENT should be defined"
#endif  /* MQ_SERVER */

--------------060601000705060302040908--
