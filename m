Return-Path: <linux-kernel-owner+w=401wt.eu-S1765141AbZFQIfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765141AbZFQIfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764435AbZFQIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:35:34 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:60885 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbZFQIfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PuO4pnm+Wp3XF4fSX2W1n4LSoY64ByjOfLa6lG7HKgivTdHPeKHN6nxYV6G01AWFDi
         uOLCzPZYzenBIBQOF8VKeepRespuoPh3JpysxFNYglxBQCx0zylQl6Qegx5oCJ259PaJ
         75ZujntJ8yLc4bmWUJrbP3CkFlwCC6JgFVJD0=
MIME-Version: 1.0
In-Reply-To: <20090606064749.GA13508@redhat.com>
References: <20090525185502.GA20781@redhat.com>
	 <20090526210514.C1C91FC2BD@magilla.sf.frob.com>
	 <20090526213346.GA7073@redhat.com>
	 <20090527005527.B50B7FC36B@magilla.sf.frob.com>
	 <20090602045418.GB8219@us.ibm.com>
	 <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com>
	 <20090606064749.GA13508@redhat.com>
Date: Wed, 17 Jun 2009 14:05:31 +0530
Message-ID: <f5a7b3810906170135q3fd90f8fy8c5e06ab77e26b52@mail.gmail.com>
Subject: Re: open_posix_testsuite: STOP + CONT + wait hang?
From: naresh kamboju <naresh.kernel@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd403faa110ca046c872c38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd403faa110ca046c872c38
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Oleg,

please find inline comments

On Sat, Jun 6, 2009 at 12:17 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> (change the subject)
>
> On 06/05, naresh kamboju wrote:
>>
>> I want to inform 2.6.29 signal issues,
>> As per my understanding I have noticed that if there is a delay
>> (sleep/nanosleep/usleep) in the child process. Child could not
>> reporting exit status to parent at this situation parent is waiting
>> for ever by combinations of SIGSTOP and SIGCONT. So test cases are
>> reporting as HUNG.
>
> Thanks for report, but please provide more info.
>
>> ARCH: ARM
>
> is it ARM specific? I can't reproduce the problem on x86.
yes it is specific to ARM. test cases are PASSED on X86-2.6.29 Kernels.
>
>> KERNEL: 2.6.29.1
>
> did you try other kernel versions?
i have tried on 2.6.23 kernels it is PASSED on both ARM and X68.
>
>> #define SLEEPSEC 5
> ...
>> =A0 =A0 =A0 if ((pid =3D fork()) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* child here */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct timespec tssleep;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tssleep.tv_sec=3DSLEEPSEC;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tssleep.tv_nsec=3D0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (clock_nanosleep(CLOCK_REALTIME, 0, &tssl=
eep, NULL) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("clock_nanosleep() re=
turned success\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CHILDPASS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("clock_nanosleep() di=
d not return success\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CHILDFAIL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return CHILDFAIL;
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* parent here */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sleep(1);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (kill(pid, SIGSTOP) !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("Could not raise SIGS=
TOP\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTS_UNRESOLVED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (kill(pid, SIGCONT) !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf("Could not raise SIGC=
ONT\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTS_UNRESOLVED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait(&i) =3D=3D -1) {
>
> And I guess it hangs here, right?
yes.
it is hangs here.
wait4(-1, Process 464 suspended

>
> The child should sleep SLEEPSEC seconds then exit, so the whole
> test-case should take SLEEPSEC seconds too.
yes. that is the expected.
>
>
> Do you mean it really hangs and never completes?
yes. it is hangs and never completes.
>
> Can you confirm it hangs in wait() ?
yes. wait4() syscall is waiting for child status.

>
> Does the child print "returned success" ?
it is not notifying parent about its exit status.

>
> If you can reproduce the problem, please send the content of
> /proc/CHILD_PID/status and /proc/PARENT_PID/status.

i have attached  strace and proc_log
please review the same.

Best regards
Naresh Kamboju
>
> Oleg.
execve("./3-2.test", ["./3-2.test"], [/* 10 vars */]) =3D 0
brk(0)                                  =3D 0x11000
uname({sys=3D"Linux", node=3D"43.88.101.211", ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x4001d000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/devel/etc/ld.so.cache", O_RDONLY) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D13962, ...}) =3D 0
mmap2(NULL, 13962, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x4001e000
close(3)                                =3D 0
open("/devel/lib/libpthread.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0008B\0\0004\0\0\0\20=
0"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D805190, ...}) =3D 0
mmap2(NULL, 127472, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40026000
mprotect(0x4003a000, 32768, PROT_NONE)  =3D 0
mmap2(0x40042000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14) =3D 0x40042000
mmap2(0x40044000, 4592, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x40044000
close(3)                                =3D 0
open("/devel/lib/librt.so.1", O_RDONLY) =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\240\26\0\0004\0\0\0=
\4"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D163621, ...}) =3D 0
mmap2(NULL, 57876, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40046000
mprotect(0x4004c000, 28672, PROT_NONE)  =3D 0
mmap2(0x40053000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) =3D 0x40053000
close(3)                                =3D 0
open("/devel/lib/libm.so.6", O_RDONLY)  =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\2601\0\0004\0\0\0\3=
24"...,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1349258, ...}) =3D 0
mmap2(NULL, 688288, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) =3D 0x40055000
mprotect(0x400f5000, 28672, PROT_NONE)  =3D 0
mmap2(0x400fc000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x9f) =3D 0x400fc000
close(3)                                =3D 0
open("/devel/lib/libc.so.6", O_RDONLY)  =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0
R\1\0004\0\0\0\204"..., 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D7855285, ...}) =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x40022000
mmap2(NULL, 1249800, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) =3D 0x400fe000
mprotect(0x40223000, 28672, PROT_NONE)  =3D 0
mmap2(0x4022a000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x124) =3D 0x4022a000
mmap2(0x4022d000, 8712, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0x4022d000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0x40023000
set_tls(0x40022c80, 0x40022c80, 0x67c, 0x40023358, 0x40025048) =3D 0
mprotect(0x4022a000, 8192, PROT_READ)   =3D 0
mprotect(0x400fc000, 4096, PROT_READ)   =3D 0
mprotect(0x40053000, 4096, PROT_READ)   =3D 0
mprotect(0x40042000, 4096, PROT_READ)   =3D 0
mprotect(0x40024000, 4096, PROT_READ)   =3D 0
munmap(0x4001e000, 13962)               =3D 0
set_tid_address(0x40022828)             =3D 464
set_robust_list(0x40022830, 0xc)        =3D 0
rt_sigaction(SIGRTMIN, {0x4002a128, [], SA_SIGINFO|0x4000000}, NULL, 8) =3D=
 0
rt_sigaction(SIGRT_1, {0x40029ce8, [],
SA_RESTART|SA_SIGINFO|0x4000000}, NULL, 8) =3D 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) =3D 0
getrlimit(RLIMIT_STACK, {rlim_cur=3D8192*1024, rlim_max=3DRLIM_INFINITY}) =
=3D 0
clock_gettime(CLOCK_REALTIME, {1245240048, 291313608}) =3D 0
clone(Process 465 attached (waiting for parent)
Process 465 resumed (parent 464 ready)
child_stack=3D0, flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=3D0x40022828) =3D 465
[pid   465] nanosleep({5, 0},  <unfinished ...>
[pid   464] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) =3D 0
[pid   464] rt_sigaction(SIGCHLD, NULL, {SIG_DFL, [], 0}, 8) =3D 0
[pid   464] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
[pid   464] nanosleep({1, 0}, {1, 0})   =3D 0
[pid   464] kill(465, SIGSTOP <unfinished ...>
[pid   465] <... nanosleep resumed> 0)  =3D ? ERESTART_RESTARTBLOCK (To
be restarted)
[pid   465] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
[pid   465] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
[pid   464] <... kill resumed> )        =3D 0
[pid   464] kill(465, SIGCONT)          =3D 0
[pid   464] wait4(-1, Process 464 suspended
 <unfinished ...>
[pid   465] --- SIGCONT (Continued) @ 0 (0) ---


/**************************************************************/

-bash-3.2# uname -a
Linux 2.6.29.2
-bash-3.2# cat proc/464/status
Name:   3-2.test
State:  T (tracing stop)
Tgid:   464
Pid:    464
PPid:   462
TracerPid:      462
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 32
Groups: 0
VmPeak:     2332 kB
VmSize:     2316 kB
VmLck:         0 kB
VmHWM:       404 kB
VmRSS:       404 kB
VmData:       32 kB
VmStk:        84 kB
VmExe:         4 kB
VmLib:      2032 kB
VmPTE:         8 kB
Threads:        1
SigQ:   0/1024
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000180000000
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        126
nonvoluntary_ctxt_switches:     31
-bash-3.2#
-bash-3.2# cat proc/465/status
Name:   3-2.test
State:  R (running)
Tgid:   465
Pid:    465
PPid:   464
TracerPid:      462
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 32
Groups: 0
VmPeak:     2316 kB
VmSize:     2316 kB
VmLck:         0 kB
VmHWM:       164 kB
VmRSS:       164 kB
VmData:       32 kB
VmStk:        84 kB
VmExe:         4 kB
VmLib:      2032 kB
VmPTE:         8 kB
Threads:        1
SigQ:   0/1024
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000180000000
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        7
nonvoluntary_ctxt_switches:     36623
-bash-3.2#



>
>

--000e0cd403faa110ca046c872c38
Content-Type: text/plain; charset=US-ASCII; name="proc_log.txt"
Content-Disposition: attachment; filename="proc_log.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw1sdnnc1

LWJhc2gtMy4yIyB1bmFtZSAtYQ0KTGludXggMi42LjI5LjIgDQotYmFzaC0zLjIjIGNhdCBwcm9j
LzQ2NC9zdGF0dXMNCk5hbWU6ICAgMy0yLnRlc3QNClN0YXRlOiAgVCAodHJhY2luZyBzdG9wKQ0K
VGdpZDogICA0NjQNClBpZDogICAgNDY0DQpQUGlkOiAgIDQ2Mg0KVHJhY2VyUGlkOiAgICAgIDQ2
Mg0KVWlkOiAgICAwICAgICAgIDAgICAgICAgMCAgICAgICAwDQpHaWQ6ICAgIDAgICAgICAgMCAg
ICAgICAwICAgICAgIDANCkZEU2l6ZTogMzINCkdyb3VwczogMA0KVm1QZWFrOiAgICAgMjMzMiBr
Qg0KVm1TaXplOiAgICAgMjMxNiBrQg0KVm1MY2s6ICAgICAgICAgMCBrQg0KVm1IV006ICAgICAg
IDQwNCBrQg0KVm1SU1M6ICAgICAgIDQwNCBrQg0KVm1EYXRhOiAgICAgICAzMiBrQg0KVm1TdGs6
ICAgICAgICA4NCBrQg0KVm1FeGU6ICAgICAgICAgNCBrQg0KVm1MaWI6ICAgICAgMjAzMiBrQg0K
Vm1QVEU6ICAgICAgICAgOCBrQg0KVGhyZWFkczogICAgICAgIDENClNpZ1E6ICAgMC8xMDI0DQpT
aWdQbmQ6IDAwMDAwMDAwMDAwMDAwMDANClNoZFBuZDogMDAwMDAwMDAwMDAwMDAwMA0KU2lnQmxr
OiAwMDAwMDAwMDAwMDAwMDAwDQpTaWdJZ246IDAwMDAwMDAwMDAwMDAwMDANClNpZ0NndDogMDAw
MDAwMDE4MDAwMDAwMA0KQ2FwSW5oOiAwMDAwMDAwMDAwMDAwMDAwDQpDYXBQcm06IGZmZmZmZmZm
ZmZmZmZlZmYNCkNhcEVmZjogZmZmZmZmZmZmZmZmZmVmZg0KQ2FwQm5kOiBmZmZmZmZmZmZmZmZm
ZWZmDQp2b2x1bnRhcnlfY3R4dF9zd2l0Y2hlczogICAgICAgIDEyNg0Kbm9udm9sdW50YXJ5X2N0
eHRfc3dpdGNoZXM6ICAgICAzMQ0KLWJhc2gtMy4yIw0KLWJhc2gtMy4yIyBjYXQgcHJvYy80NjUv
c3RhdHVzDQpOYW1lOiAgIDMtMi50ZXN0DQpTdGF0ZTogIFIgKHJ1bm5pbmcpDQpUZ2lkOiAgIDQ2
NQ0KUGlkOiAgICA0NjUNClBQaWQ6ICAgNDY0DQpUcmFjZXJQaWQ6ICAgICAgNDYyDQpVaWQ6ICAg
IDAgICAgICAgMCAgICAgICAwICAgICAgIDANCkdpZDogICAgMCAgICAgICAwICAgICAgIDAgICAg
ICAgMA0KRkRTaXplOiAzMg0KR3JvdXBzOiAwDQpWbVBlYWs6ICAgICAyMzE2IGtCDQpWbVNpemU6
ICAgICAyMzE2IGtCDQpWbUxjazogICAgICAgICAwIGtCDQpWbUhXTTogICAgICAgMTY0IGtCDQpW
bVJTUzogICAgICAgMTY0IGtCDQpWbURhdGE6ICAgICAgIDMyIGtCDQpWbVN0azogICAgICAgIDg0
IGtCDQpWbUV4ZTogICAgICAgICA0IGtCDQpWbUxpYjogICAgICAyMDMyIGtCDQpWbVBURTogICAg
ICAgICA4IGtCDQpUaHJlYWRzOiAgICAgICAgMQ0KU2lnUTogICAwLzEwMjQNClNpZ1BuZDogMDAw
MDAwMDAwMDAwMDAwMA0KU2hkUG5kOiAwMDAwMDAwMDAwMDAwMDAwDQpTaWdCbGs6IDAwMDAwMDAw
MDAwMDAwMDANClNpZ0lnbjogMDAwMDAwMDAwMDAwMDAwMA0KU2lnQ2d0OiAwMDAwMDAwMTgwMDAw
MDAwDQpDYXBJbmg6IDAwMDAwMDAwMDAwMDAwMDANCkNhcFBybTogZmZmZmZmZmZmZmZmZmVmZg0K
Q2FwRWZmOiBmZmZmZmZmZmZmZmZmZWZmDQpDYXBCbmQ6IGZmZmZmZmZmZmZmZmZlZmYNCnZvbHVu
dGFyeV9jdHh0X3N3aXRjaGVzOiAgICAgICAgNw0Kbm9udm9sdW50YXJ5X2N0eHRfc3dpdGNoZXM6
ICAgICAzNjYyMw0KLWJhc2gtMy4yIw==
--000e0cd403faa110ca046c872c38
Content-Type: application/octet-stream; name="nano_sleep_3-2.log"
Content-Disposition: attachment; filename="nano_sleep_3-2.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw1sdc7h0

ZXhlY3ZlKCIuLzMtMi50ZXN0IiwgWyIuLzMtMi50ZXN0Il0sIFsvKiAxMCB2YXJzICovXSkgPSAw
CmJyaygwKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4MTEwMDAKdW5hbWUo
e3N5cz0iTGludXgiLCBub2RlPSI0My44OC4xMDEuMjExIiwgLi4ufSkgPSAwCm1tYXAyKE5VTEws
IDQwOTYsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VTLCAt
MSwgMCkgPSAweDQwMDFkMDAwCmFjY2VzcygiL2V0Yy9sZC5zby5wcmVsb2FkIiwgUl9PSykgICAg
ICA9IC0xIEVOT0VOVCAoTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKb3BlbigiL2RldmVsL2V0
Yy9sZC5zby5jYWNoZSIsIE9fUkRPTkxZKSA9IDMKZnN0YXQ2NCgzLCB7c3RfbW9kZT1TX0lGUkVH
fDA2NDQsIHN0X3NpemU9MTM5NjIsIC4uLn0pID0gMAptbWFwMihOVUxMLCAxMzk2MiwgUFJPVF9S
RUFELCBNQVBfUFJJVkFURSwgMywgMCkgPSAweDQwMDFlMDAwCmNsb3NlKDMpICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbigiL2RldmVsL2xpYi9saWJwdGhyZWFkLnNvLjAi
LCBPX1JET05MWSkgPSAzCnJlYWQoMywgIlwxNzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBcMFwwXDBc
M1wwKFwwXDFcMFwwXDAwMDhCXDBcMDAwNFwwXDBcMFwyMDAiLi4uLCA1MTIpID0gNTEyCmZzdGF0
NjQoMywge3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTgwNTE5MCwgLi4ufSkgPSAwCm1t
YXAyKE5VTEwsIDEyNzQ3MiwgUFJPVF9SRUFEfFBST1RfRVhFQywgTUFQX1BSSVZBVEV8TUFQX0RF
TllXUklURSwgMywgMCkgPSAweDQwMDI2MDAwCm1wcm90ZWN0KDB4NDAwM2EwMDAsIDMyNzY4LCBQ
Uk9UX05PTkUpICA9IDAKbW1hcDIoMHg0MDA0MjAwMCwgODE5MiwgUFJPVF9SRUFEfFBST1RfV1JJ
VEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDE0KSA9IDB4NDAw
NDIwMDAKbW1hcDIoMHg0MDA0NDAwMCwgNDU5MiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9Q
UklWQVRFfE1BUF9GSVhFRHxNQVBfQU5PTllNT1VTLCAtMSwgMCkgPSAweDQwMDQ0MDAwCmNsb3Nl
KDMpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDAKb3BlbigiL2RldmVsL2xpYi9s
aWJydC5zby4xIiwgT19SRE9OTFkpID0gMwpyZWFkKDMsICJcMTc3RUxGXDFcMVwxXDBcMFwwXDBc
MFwwXDBcMFwwXDNcMChcMFwxXDBcMFwwXDI0MFwyNlwwXDAwMDRcMFwwXDBcNCIuLi4sIDUxMikg
PSA1MTIKZnN0YXQ2NCgzLCB7c3RfbW9kZT1TX0lGUkVHfDA3NTUsIHN0X3NpemU9MTYzNjIxLCAu
Li59KSA9IDAKbW1hcDIoTlVMTCwgNTc4NzYsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1BUF9QUklW
QVRFfE1BUF9ERU5ZV1JJVEUsIDMsIDApID0gMHg0MDA0NjAwMAptcHJvdGVjdCgweDQwMDRjMDAw
LCAyODY3MiwgUFJPVF9OT05FKSAgPSAwCm1tYXAyKDB4NDAwNTMwMDAsIDgxOTIsIFBST1RfUkVB
RHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0RFTllXUklURSwgMywgMHg1
KSA9IDB4NDAwNTMwMDAKY2xvc2UoMykgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0g
MApvcGVuKCIvZGV2ZWwvbGliL2xpYm0uc28uNiIsIE9fUkRPTkxZKSAgPSAzCnJlYWQoMywgIlwx
NzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBcMFwwXDBcM1wwKFwwXDFcMFwwXDBcMjYwMVwwXDAwMDRc
MFwwXDBcMzI0Ii4uLiwgNTEyKSA9IDUxMgpmc3RhdDY0KDMsIHtzdF9tb2RlPVNfSUZSRUd8MDc1
NSwgc3Rfc2l6ZT0xMzQ5MjU4LCAuLi59KSA9IDAKbW1hcDIoTlVMTCwgNjg4Mjg4LCBQUk9UX1JF
QUR8UFJPVF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAwKSA9IDB4NDAwNTUw
MDAKbXByb3RlY3QoMHg0MDBmNTAwMCwgMjg2NzIsIFBST1RfTk9ORSkgID0gMAptbWFwMigweDQw
MGZjMDAwLCA4MTkyLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVE
fE1BUF9ERU5ZV1JJVEUsIDMsIDB4OWYpID0gMHg0MDBmYzAwMApjbG9zZSgzKSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgPSAwCm9wZW4oIi9kZXZlbC9saWIvbGliYy5zby42IiwgT19S
RE9OTFkpICA9IDMKcmVhZCgzLCAiXDE3N0VMRlwxXDFcMVwwXDBcMFwwXDBcMFwwXDBcMFwzXDAo
XDBcMVwwXDBcMCBSXDFcMDAwNFwwXDBcMFwyMDQiLi4uLCA1MTIpID0gNTEyCmZzdGF0NjQoMywg
e3N0X21vZGU9U19JRlJFR3wwNzU1LCBzdF9zaXplPTc4NTUyODUsIC4uLn0pID0gMAptbWFwMihO
VUxMLCA0MDk2LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9V
UywgLTEsIDApID0gMHg0MDAyMjAwMAptbWFwMihOVUxMLCAxMjQ5ODAwLCBQUk9UX1JFQUR8UFJP
VF9FWEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAwKSA9IDB4NDAwZmUwMDAKbXBy
b3RlY3QoMHg0MDIyMzAwMCwgMjg2NzIsIFBST1RfTk9ORSkgID0gMAptbWFwMigweDQwMjJhMDAw
LCAxMjI4OCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBf
REVOWVdSSVRFLCAzLCAweDEyNCkgPSAweDQwMjJhMDAwCm1tYXAyKDB4NDAyMmQwMDAsIDg3MTIs
IFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0FOT05ZTU9V
UywgLTEsIDApID0gMHg0MDIyZDAwMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgPSAwCm1tYXAyKE5VTEwsIDQwOTYsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJ
VkFURXxNQVBfQU5PTllNT1VTLCAtMSwgMCkgPSAweDQwMDIzMDAwCnNldF90bHMoMHg0MDAyMmM4
MCwgMHg0MDAyMmM4MCwgMHg2N2MsIDB4NDAwMjMzNTgsIDB4NDAwMjUwNDgpID0gMAptcHJvdGVj
dCgweDQwMjJhMDAwLCA4MTkyLCBQUk9UX1JFQUQpICAgPSAwCm1wcm90ZWN0KDB4NDAwZmMwMDAs
IDQwOTYsIFBST1RfUkVBRCkgICA9IDAKbXByb3RlY3QoMHg0MDA1MzAwMCwgNDA5NiwgUFJPVF9S
RUFEKSAgID0gMAptcHJvdGVjdCgweDQwMDQyMDAwLCA0MDk2LCBQUk9UX1JFQUQpICAgPSAwCm1w
cm90ZWN0KDB4NDAwMjQwMDAsIDQwOTYsIFBST1RfUkVBRCkgICA9IDAKbXVubWFwKDB4NDAwMWUw
MDAsIDEzOTYyKSAgICAgICAgICAgICAgID0gMApzZXRfdGlkX2FkZHJlc3MoMHg0MDAyMjgyOCkg
ICAgICAgICAgICAgPSA0NjQKc2V0X3JvYnVzdF9saXN0KDB4NDAwMjI4MzAsIDB4YykgICAgICAg
ID0gMApydF9zaWdhY3Rpb24oU0lHUlRNSU4sIHsweDQwMDJhMTI4LCBbXSwgU0FfU0lHSU5GT3ww
eDQwMDAwMDB9LCBOVUxMLCA4KSA9IDAKcnRfc2lnYWN0aW9uKFNJR1JUXzEsIHsweDQwMDI5Y2U4
LCBbXSwgU0FfUkVTVEFSVHxTQV9TSUdJTkZPfDB4NDAwMDAwMH0sIE5VTEwsIDgpID0gMApydF9z
aWdwcm9jbWFzayhTSUdfVU5CTE9DSywgW1JUTUlOIFJUXzFdLCBOVUxMLCA4KSA9IDAKZ2V0cmxp
bWl0KFJMSU1JVF9TVEFDSywge3JsaW1fY3VyPTgxOTIqMTAyNCwgcmxpbV9tYXg9UkxJTV9JTkZJ
TklUWX0pID0gMApjbG9ja19nZXR0aW1lKENMT0NLX1JFQUxUSU1FLCB7MTI0NTI0MDA0OCwgMjkx
MzEzNjA4fSkgPSAwCmNsb25lKFByb2Nlc3MgNDY1IGF0dGFjaGVkICh3YWl0aW5nIGZvciBwYXJl
bnQpClByb2Nlc3MgNDY1IHJlc3VtZWQgKHBhcmVudCA0NjQgcmVhZHkpCmNoaWxkX3N0YWNrPTAs
IGZsYWdzPUNMT05FX0NISUxEX0NMRUFSVElEfENMT05FX0NISUxEX1NFVFRJRHxTSUdDSExELCBj
aGlsZF90aWRwdHI9MHg0MDAyMjgyOCkgPSA0NjUKW3BpZCAgIDQ2NV0gbmFub3NsZWVwKHs1LCAw
fSwgIDx1bmZpbmlzaGVkIC4uLj4KW3BpZCAgIDQ2NF0gcnRfc2lncHJvY21hc2soU0lHX0JMT0NL
LCBbQ0hMRF0sIFtdLCA4KSA9IDAKW3BpZCAgIDQ2NF0gcnRfc2lnYWN0aW9uKFNJR0NITEQsIE5V
TEwsIHtTSUdfREZMLCBbXSwgMH0sIDgpID0gMApbcGlkICAgNDY0XSBydF9zaWdwcm9jbWFzayhT
SUdfU0VUTUFTSywgW10sIE5VTEwsIDgpID0gMApbcGlkICAgNDY0XSBuYW5vc2xlZXAoezEsIDB9
LCB7MSwgMH0pICAgPSAwCltwaWQgICA0NjRdIGtpbGwoNDY1LCBTSUdTVE9QIDx1bmZpbmlzaGVk
IC4uLj4KW3BpZCAgIDQ2NV0gPC4uLiBuYW5vc2xlZXAgcmVzdW1lZD4gMCkgID0gPyBFUkVTVEFS
VF9SRVNUQVJUQkxPQ0sgKFRvIGJlIHJlc3RhcnRlZCkKW3BpZCAgIDQ2NV0gLS0tIFNJR1NUT1Ag
KFN0b3BwZWQgKHNpZ25hbCkpIEAgMCAoMCkgLS0tCltwaWQgICA0NjVdIC0tLSBTSUdTVE9QIChT
dG9wcGVkIChzaWduYWwpKSBAIDAgKDApIC0tLQpbcGlkICAgNDY0XSA8Li4uIGtpbGwgcmVzdW1l
ZD4gKSAgICAgICAgPSAwCltwaWQgICA0NjRdIGtpbGwoNDY1LCBTSUdDT05UKSAgICAgICAgICA9
IDAKW3BpZCAgIDQ2NF0gd2FpdDQoLTEsIFByb2Nlc3MgNDY0IHN1c3BlbmRlZAogPHVuZmluaXNo
ZWQgLi4uPgpbcGlkICAgNDY1XSAtLS0gU0lHQ09OVCAoQ29udGludWVkKSBAIDAgKDApIC0tLQo=
--000e0cd403faa110ca046c872c38--
