Return-Path: <linux-kernel-owner+w=401wt.eu-S1030836AbXCNNfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030836AbXCNNfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXCNNfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:35:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37114 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXCNNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=ehkcofUCauJHw1EZ85N++8UrteNpF7utku99K0pMhXHSyvAy5jIuVf1IK0hEiqskK//qjCC2gMRquG2nkb40Vvxy8euaaxk11GrYJ7sPkl/XHLNg83y1wT118BqeJvMVZmfv3t4EtvU2pX1h23V25OBvZXaLZUUcaofKkaLWs2k=
Message-ID: <45F7FA3B.6070303@atnn.ru>
Date: Wed, 14 Mar 2007 16:35:55 +0300
Reply-To: kostik@atnn.ru
User-Agent: Thunderbird 1.5.0.5 (Windows/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kswapd & 2.4.21-47.0.0.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Konstantin Kalin <konstantin.kalin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, All

I have the following configuration: CentOS 3.8, kernel 
2.4.21-41.0.01.EL, Dialogic boards.
Sometimes a kernel panic happens. I setup netdump and got several crash 
dumps and logs. Backtrace shows that kswapd called BUG in try_to_unmap 
function. Unfortunately I couldn't upgrade the kernel because of 
proprietary Dialogic drivers which are precompiled.

Could somebody help me? I tried to find similar issues in maillist and 
failed with it. There are a few messages but they describe another case.
As I understand the rmap.c are under active development and it's 
strongly been changing per each kernel version. Also if I understand 
correct rmap.c has appeared in the kernel 2.6.x and my version of the 
kernel is a backport by RedHat from 2.6 to 2.4.

Information about the crash is below. The specific of my system is a lot 
of java thread (up to 1500).

Best regards,
Kostya.

--------------------------------

crash 4.0-2.30
Copyright (C) 2002, 2003, 2004, 2005, 2006  Red Hat, Inc.
Copyright (C) 2004, 2005, 2006  IBM Corporation
Copyright (C) 1999-2006  Hewlett-Packard Co
Copyright (C) 2005  Fujitsu Limited
Copyright (C) 2005  NEC Corporation
Copyright (C) 1999, 2002  Silicon Graphics, Inc.
Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
This program is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.  Enter "help copying" to see the conditions.
This program has absolutely no warranty.  Enter "help warranty" for details.

WARNING: /usr/lib/debug/boot/vmlinux-2.4.21-47.0.1.EL.debug:
        CRC value does not match

GNU gdb 6.1
Copyright 2004 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain 
conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i686-pc-linux-gnu"...

     KERNEL: /root/vmlinux-2.4.21-47.0.1.EL
  DEBUGINFO: /usr/lib/debug/boot/vmlinux-2.4.21-47.0.1.EL.debug
   DUMPFILE: vmcore
       CPUS: 1
       DATE: Tue Mar 13 00:06:05 2007
     UPTIME: 02:23:16
LOAD AVERAGE: 3.36, 1.64, 0.68
      TASKS: 2627
   NODENAME: ple-dev-dh1
    RELEASE: 2.4.21-47.0.1.EL
    VERSION: #1 Thu Oct 19 11:42:25 EDT 2006
    MACHINE: i686  (931 Mhz)
     MEMORY: 1 GB
      PANIC: "kernel BUG at rmap.c:498!"
        PID: 4
    COMMAND: "kswapd"
       TASK: c37b8000
        CPU: 0
      STATE: TASK_RUNNING (PANIC)

crash> bt -f
PID: 4      TASK: c37b8000  CPU: 0   COMMAND: "kswapd"
#0 [c37b9e54] netconsole_netdump at f89f9586
   [RA: c0121225  SP: c37b9e54  FP: c37b9e64  SIZE: 20]
   c37b9e54: c37b9f34  00000000  c37b9f34  00000000
   c37b9e64: c0121225
#1 [c37b9e64] try_crashdump at c0121223
   [RA: c010c2d7  SP: c37b9e68  FP: c37b9e74  SIZE: 16]
   c37b9e68: c37b9f34  00000000  c37b9f34  c010c2d7
#2 [c37b9e74] die at c010c2d2
   [RA: c010c4e7  SP: c37b9e78  FP: c37b9e88  SIZE: 20]
   c37b9e78: c37b9f34  c028d975  00000000  c37b8000
   c37b9e88: c010c4e7
#3 [c37b9e88] do_invalid_op at c010c4e2
   [RA: c02841c2  SP: c37b9e8c  FP: c37b9f28  SIZE: 160]
   c37b9e8c: c028d975  c37b9f34  00000000  00000000
   c37b9e9c: c37b9f34  00000000  c37b9ea8  00000004
   c37b9eac: 00000000  00030002  c0152280  cf4e4510
   c37b9ebc: c1037380  00000000  cf4e4510  00000008
   c37b9ecc: 00000001  cf4e4510  c01ba06b  00000001
   c37b9edc: cf4e4510  cf4e4510  cf4e4510  cf4e4510
   c37b9eec: c0159e64  c1037380  cf4e4510  00001000
   c37b9efc: c1037380  c1037380  c034db00  c014c400
   c37b9f0c: c014a9be  00000001  c1037380  00000302
   c37b9f1c: c37b9f34  00001000  00001000  c02841c2
#4 [c37b9f28] error_code (via invalid_op) at c02841c0
   EAX: 00048159  EBX: c1001194  ECX: 000003ba  EDX: f885d000  EBP: c1001178
   DS:  0068      ESI: c1001178  ES:  0068      EDI: ffffffff
   CS:  0060      EIP: c0152280  ERR: ffffffff  EFLAGS: 00010206
   [RA: c0152280  SP: c37b9f34  FP: c37b9f64  SIZE: 52]
   c37b9f34: c1001194  000003ba  f885d000  c1001178
   c37b9f44: ffffffff  c1001178  00048159  00030068
   c37b9f54: 00000068  ffffffff  c0152280  00000060
   c37b9f64: 00010206
#5 [c37b9f64] try_to_unmap at c0152280
   [RA: c0147d13  SP: c37b9f68  FP: c37b9f88  SIZE: 36]
   c37b9f68: c1001178  c014c5c7  00000000  0003ba00
   c37b9f78: c1001194  c1001178  c034db00  00001000
   c37b9f88: c0147d13
#6 [c37b9f88] launder_page at c0147d0e
   [RA: c014901b  SP: c37b9f8c  FP: c37b9fa8  SIZE: 32]
   c37b9f8c: c1001178  000001d0  00000000  00000116
   c37b9f9c: c034db00  00000001  00000000  c014901b
#7 [c37b9fa8] rebalance_dirty_zone at c0149016
   [RA: c0149826  SP: c37b9fac  FP: c37b9fd0  SIZE: 40]
   c37b9fac: c034db00  000001d0  c1001178  c034dd3c
   c37b9fbc: 00000020  c034db00  00000032  00000001
   c37b9fcc: 00000000  c0149826
#8 [c37b9fd0] kswapd at c0149821
   [RA: c010947d  SP: c37b9fd4  FP: c37b9ff0  SIZE: 32]
   c37b9fd4: c034db00  00000040  000001d0  00000068
   c37b9fe4: c01496b0  00000000  00000000  c010947d
#9 [c37b9ff0] kernel_thread_helper at c010947b
   [RA: 0  SP: c37b9fd4  FP: c37b9ffc  SIZE: 16]
   c37b9fd4: 00000000  00000000  00000000  00000000

crash> ps
  PID    PPID  CPU   TASK    ST  %MEM     VSZ    RSS  COMM
     0      0   0  c0392000  RU   0.0       0      0  [swapper]
     1      0   0  c39be000  IN   0.0    1524    492  init
     2      1   0  c211e000  IN   0.0       0      0  [keventd]
     3      1   0  c37ba000  RU   0.0       0      0  [ksoftirqd/0]
 >    4      1   0  c37b8000  RU   0.0       0      0  [kswapd]
     5      1   0  f7fc6000  IN   0.0       0      0  [kscand]
     6      1   0  f7fc4000  IN   0.0       0      0  [bdflush]
     7      1   0  f7fc2000  IN   0.0       0      0  [kupdated]
     8      1   0  c37b0000  IN   0.0       0      0  [mdrecoveryd]
    12      1   0  f7794000  IN   0.0       0      0  [kjournald]
    67      1   0  c35b6000  IN   0.0       0      0  [khubd]
   559      1   0  f7702000  IN   0.0       0      0  [kjournald]
   949      1   0  c2190000  IN   0.1    1588    612  syslogd
   953      1   0  c377c000  IN   0.0    1540    456  klogd
   979      1   0  c3768000  IN   0.0    1656    520  portmap
   998      1   0  c3762000  IN   0.1    1664    640  rpc.statd
  1009      1   0  c374e000  IN   0.0    1584    400  mdadm
  1162      1   0  f7f00000  IN   0.2    7596   1600  cupsd
  1183      1   0  f762c000  IN   0.1    3656   1456  sshd
  1197      1   0  f7616000  IN   0.1    2136    692  xinetd
  1277      1   0  c3660000  IN   0.2    6104   1952  sendmail
  1286      1   0  c3650000  IN   0.2    5980   1780  sendmail
  1313      1   0  c363c000  IN   0.7  185552   7700  eventserv
  1330      1   0  c364e000  IN   0.7   83396   7060  nameserv
  1347      1   0  f7eda000  IN   0.1    4472    992  crond
  2376      1   0  f7e60000  IN   0.7  185552   7700  eventserv
  2377      1   0  f7e5e000  IN   0.7   83396   7060  nameserv
  2401      1   0  f7e50000  IN   0.7   51832   7172  dlgsysloggerser
  2437      1   0  f7e12000  IN   0.8   32132   7920  devmapserver
  2498      1   0  c3bb2000  IN   0.7   83396   7060  nameserv
  2516      1   0  c3bb8000  IN   0.7   42156   7528  dlgtimeslotdole
  2602      1   0  c3b5c000  IN   0.9  106216   9124  dlgsysmonitorse
  2626      1   0  c3b4e000  IN   0.9  106216   9124  dlgsysmonitorse
  2632      1   0  c3b4c000  IN   0.9  106216   9124  dlgsysmonitorse
  2636      1   0  c3b46000  IN   0.9  106216   9124  dlgsysmonitorse
  2670      1   0  c3b1a000  IN   0.7  185552   7700  eventserv
  2671      1   0  c3b3c000  IN   0.7  185552   7700  eventserv
  2672      1   0  c3b18000  IN   0.7  185552   7700  eventserv
  2673      1   0  c3b44000  IN   0.7  185552   7700  eventserv
  2712      1   0  c3b0e000  IN   0.9  106216   9124  dlgsysmonitorse
  2729      1   0  c3b2c000  IN   0.8   55012   8848  dlgsysclockserv
  2753      1   0  c3af8000  IN   0.8   55012   8848  dlgsysclockserv
  2774      1   0  c3afc000  IN   0.8   55012   8848  dlgsysclockserv
  3005      1   0  ebd04000  IN   0.7   42156   7528  dlgtimeslotdole
  3185      1   0  dd632000  IN   0.8   75236   8704  dlgclockdaemon
  3237      1   0  dbcd8000  IN   0.8   75236   8704  dlgclockdaemon
  3244      1   0  dbcf8000  IN   0.7  185552   7700  eventserv
  3245      1   0  e5a78000  IN   0.8   75236   8704  dlgclockdaemon
  3266      1   0  dbc6c000  IN   0.8   75236   8704  dlgclockdaemon
  3269      1   0  e5628000  IN   0.8   75236   8704  dlgclockdaemon
  3271      1   0  db912000  IN   0.8   75236   8704  dlgclockdaemon
  3281      1   0  db786000  IN   0.7  185552   7700  eventserv
  3282      1   0  db77c000  IN   0.7  185552   7700  eventserv
  3309      1   0  db1ee000  IN   0.7  185552   7700  eventserv
  3310      1   0  db1f0000  IN   0.9  106216   9124  dlgsysmonitorse
  3317      1   0  db054000  IN   0.9  106216   9124  dlgsysmonitorse
  3334      1   0  f7ed8000  IN   1.4  158652  14328  boardserver
  3478      1   0  d8278000  IN   0.7   74448   7676  dlgctrapservd
  3510      1   0  d734a000  IN   0.1    1596    584  atd
  3536      1   0  d6fd4000  IN   1.4  158652  14328  boardserver
  3544      1   0  d69c0000  IN   0.7  185552   7700  eventserv
  3545      1   0  d699c000  IN   1.4  158652  14328  boardserver
  3563      1   0  d6994000  IN   0.7   83396   7060  nameserv
  3564      1   0  d6992000  IN   1.4  158652  14328  boardserver
  3629      1   0  d6518000  IN   0.7  185552   7700  eventserv
  3630      1   0  d663c000  IN   0.7   74448   7676  dlgctrapservd
  3684      1   0  f760e000  IN   0.0    1512    424  mingetty
  3685      1   0  d6944000  IN   0.0    1524    428  mingetty
  3686      1   0  d64b6000  IN   0.0    1524    424  mingetty
  3687      1   0  d63cc000  IN   0.0    1520    428  mingetty
  3688      1   0  d63ca000  IN   0.0    1528    428  mingetty
  3689      1   0  d646a000  IN   0.0    1516    428  mingetty
  3695      1   0  d64c2000  IN   0.7   83396   7060  nameserv
  3696      1   0  d63c2000  IN   0.7   74448   7676  dlgctrapservd
  3703      1   0  d63c4000  IN   1.4  158652  14328  boardserver
  3704      1   0  d63ba000  IN   1.4  158652  14328  boardserver
  3705      1   0  d63b8000  IN   1.4  158652  14328  boardserver
  3709      1   0  d639e000  IN   0.7  185552   7700  eventserv
  3710      1   0  d6332000  IN   1.4  158652  14328  boardserver
  3711      1   0  d61e6000  IN   1.4  158652  14328  boardserver
  3715      1   0  d61d4000  IN   0.7  185552   7700  eventserv
  3716      1   0  d61ce000  IN   0.7  185552   7700  eventserv
  3717      1   0  d61b6000  IN   0.7  185552   7700  eventserv
  3718      1   0  d619a000  IN   1.4  158652  14328  boardserver
  3719      1   0  d6156000  IN   1.4  158652  14328  boardserver
  3796      1   0  d5fd8000  IN   1.4  158652  14328  boardserver
  3797      1   0  d5fd6000  IN   0.7   74448   7676  dlgctrapservd
  6155   1183   0  d312a000  IN   0.2    6852   1968  sshd
  6158   6155   0  d43be000  IN   0.2    7036   2172  sshd
  6159   6158   0  d259a000  IN   0.1    4260   1396  bash
 10982   1183   0  edde0000  IN   0.2    6852   1988  sshd
 10987  10982   0  eabaa000  IN   0.2    7036   2204  sshd
 10988  10987   0  ea424000  IN   0.1    4256   1384  bash
 11135      1   0  f7104000  IN   0.1    4192   1100  run.sh
 11144  11135   0  eaab6000  IN  45.8 1877952 480340  java
 11145  11135   0  e147c000  IN  45.8 1877952 480340  java
 11146  11135   0  d5faa000  IN  45.8 1877952 480340  java
 11147  11135   0  f7106000  IN  45.8 1877952 480340  java
 11148  11135   0  efc38000  IN  45.8 1877952 480340  java
 11149  11135   0  ceac4000  IN  45.8 1877952 480340  java
 11150  11135   0  dd5f0000  IN  45.8 1877952 480340  java
 11151  11135   0  ec2b2000  IN  45.8 1877952 480340  java
 11152  11135   0  efaf6000  IN  45.8 1877952 480340  java
 11153  11135   0  f02f2000  IN  45.8 1877952 480340  java
 11159  10988   0  c7cd6000  IN   0.1    3892    688  tail
 11160  11135   0  e5b12000  IN  45.8 1877952 480340  java
 11161  11135   0  ea47a000  IN  45.8 1877952 480340  java
 11162  11135   0  d600c000  IN  45.8 1877952 480340  java
 11163  11135   0  eb804000  IN  45.8 1877952 480340  java
 11164  11135   0  ef6f0000  IN  45.8 1877952 480340  java
 11165  11135   0  f54aa000  IN  45.8 1877952 480340  java
 11166  11135   0  efccc000  IN  45.8 1877952 480340  java
 11167  11135   0  c84c6000  IN  45.8 1877952 480340  java
 11168  11135   0  e9406000  IN  45.8 1877952 480340  java
 11169  11135   0  e12d6000  IN  45.8 1877952 480340  java
 11170  11135   0  e9176000  IN  45.8 1877952 480340  java
 11171  11135   0  e2316000  IN  45.8 1877952 480340  java
 11172  11135   0  c86ee000  IN  45.8 1877952 480340  java
 11173  11135   0  d9eba000  IN  45.8 1877952 480340  java
 11174  11135   0  f4196000  IN  45.8 1877952 480340  java
 11175  11135   0  d756c000  IN  45.8 1877952 480340  java
 11176  11135   0  c9c7e000  IN  45.8 1877952 480340  java
 11177  11135   0  c2bc2000  IN  45.8 1877952 480340  java
 11178  11135   0  c9ef8000  IN  45.8 1877952 480340  java
 11179  11135   0  c9e9c000  IN  45.8 1877952 480340  java
 11180  11135   0  ca06a000  IN  45.8 1877952 480340  java
 11181  11135   0  d3788000  IN  45.8 1877952 480340  java
 11182  11135   0  c074a000  IN  45.8 1877952 480340  java
 11187  11135   0  c4300000  IN  45.8 1877952 480340  java
 11188  11135   0  c437e000  IN  45.8 1877952 480340  java
 11189  11135   0  c437c000  IN  45.8 1877952 480340  java
 11190  11135   0  c437a000  IN  45.8 1877952 480340  java
 11191  11135   0  c4378000  IN  45.8 1877952 480340  java
 11192  11135   0  c4376000  IN  45.8 1877952 480340  java
......
 13810  11135   0  d121e000  IN  45.8 1877952 480340  java
 13811  11135   0  d121c000  IN  45.8 1877952 480340  java
 13812  11135   0  d121a000  IN  45.8 1877952 480340  java
 13813  11135   0  d1218000  IN  45.8 1877952 480340  java
 13814  11135   0  d1202000  IN  45.8 1877952 480340  java
 13815  11135   0  d37ce000  IN  45.8 1877952 480340  java
 13816  11135   0  d37cc000  IN  45.8 1877952 480340  java
 13817  11135   0  dfec4000  IN  45.8 1877952 480340  java
 13818  11135   0  ec326000  IN  45.8 1877952 480340  java
 13819  11135   0  ec322000  IN  45.8 1877952 480340  java
 13820  11135   0  d37c6000  IN  45.8 1877952 480340  java
 13821  11135   0  d37c4000  RU  45.8 1877952 480340  java
 13822  11135   0  dc85e000  RU  45.8 1877952 480340  java
 13823  11135   0  dbf4c000  RU  45.8 1877952 480340  java
 13824  11135   0  dfedc000  RU  45.8 1877952 480340  java

