Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZJ2TPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZJ2TPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZJ2TPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:15:02 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:38502 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755037AbZJ2TPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:15:00 -0400
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       acme@redhat.com, rosted@goodmis.org, paulus@samba.org
Subject: Hard lockup with timer events
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 29 Oct 2009 20:15:03 +0100
Message-ID: <ye8hbtiko5k.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.142
X-NFIT-Solido-Score: 1.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This program

        http://www.daimi.au.dk/~sandmann/lockup.c

locks up hard for me on a Pentium 4 in 32 bit mode, with the hrtimer
patches applied (-tip for example).

What the program does is spawn a thread that just spins, and then 400
threads that each create a performance counter of type
PERF_COUNT_SW_CPU_CLOCK and a sample period of 1000000 and a
sample_type of

        PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_CALLCHAIN

These threads then map the event buffer and read it continuously.

It does not apparently lock up if SAMPLE_CALLCHAIN is removed; also I
cannot get it to lock up on Core 2 Duo in either 32 or 64 bit mode.


Soren
