Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYEQQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYEQQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYEQQvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 12:51:17 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:53368 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYEQQvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 12:51:16 -0400
X-Greylist: delayed 1203 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 12:51:16 EDT
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: linux-kernel@vger.kernel.org
Subject: CONFIG_PREEMPT causes corruption of application's FPU stack
Date: Sat, 17 May 2008 18:31:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805171831.08490.j.mell@t-online.de>
X-ID: XN2nGeZJQhIMpcaz8NB7e5XBxq-J1+gwm0Aoz4uIJ0GQFoT8BzD2Pk08TiZumoLZp4
X-TOI-MSGID: db381148-7d9b-4c8c-a05c-c37e7ee6596b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running the Einstein@home application (version 4.35, 
http://einstein.phys.uwm.edu).This application does lots of computations 
mostly with FPU and SSE instructions.
After I started experimenting with real-time optimized kernels the 
application began to crash with floating point errors like in the 
following message:

APP DEBUG: Application caught signal 8.

FPU status word ffffa0e1, flags:  ERR_SUMM STACK_FAULT PRECISION INVALID
Obtained 6 stack frames for this thread.
Use gdb command: 'info line *0xADDRESS' to print corresponding line 
numbers.
einstein_S5R3_4.35_i686-pc-linux-gnu[0x8069e7e]
einstein_S5R3_4.35_i686-pc-linux-gnu[0x818d436]
einstein_S5R3_4.35_i686-pc-linux-gnu[0x805db8f]
einstein_S5R3_4.35_i686-pc-linux-gnu[0x806b11c]
/lib/libc.so.6(__libc_start_main+0xe0)[0xb7e14fe0]
einstein_S5R3_4.35_i686-pc-linux-gnu(shmat+0x59)[0x804bda1]
Stack trace of LAL functions in worker thread:
GetSemiCohToplist at line 3177 of 
file /home/bema/einsteinathome/HierarchicalSearch/EaH_build_release_einstein_S5R3_4.35/extra_sources/lalapps-CVS/src/pulsar/hough/src2/HierarchicalSearch.c
At lowest level status code = 0, description: NO LAL ERROR REGISTERED
called boinc_finish

I tracked this down to a single kernel configuration option. If 
CONFIG_PREEMPT is set to 'y' the application will start crashing. If 
CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the application 
will run without errors.

The problem is reproducible in so far as the error always occurs when 
CONFIG_PREEMPT is set, but the time to the first occurrence varies greatly 
from some minutes up to more than 10 CPU hours.

I found this error first on an openSUSE kernel 2.6.22.17-0.1-rt. I verified 
the problem on the following kernel versions:

openSUSE 2.6.22.17-0.1-default
openSUSE 2.6.23.17-ccj64-rt
kernel.org 2.6.26-rc1
kernel.org 2.6.26-rc2-git5

My CPU is an Intel Core2Duo 6420, running two of the Einstein applications 
in 32-bit mode. From a discussion on the Einstein message boards I know 
that other user of the application are also affected.

Please let me know if you need any additional information to track this 
down.
              Jürgen
