Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0CKJtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:49:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:51935 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755183Ab0CKJtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:49:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wvIZiKxKwXKTE9oZxhjl8VKnkgQp2cxMDnbOC62
	e0oOtd3jpJ98P6
Subject: [patch 0/12] sched: fastpath cycle recovery
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:49:10 +0100
Message-Id: <1268300950.6785.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

The following patchlets take a pinned pipe-test context switch frequency
in tip from 663KHZ to 694KHZ, and an unpinned instance from 450KHz to
540KHz.  With these applied to tip.today, I have zero 31-12->today
regressions, and even some modest progressions.

The biggest difference is made by the first patch.  We have a problem
with nohz when waking cross-cpu, which given select_idle_sibling(), we
do quite a bit.  In testing netperf TCP_RR, hitting nohz code on every
micro-idle was eating ~10% of throughput, making cross-cpu wakeup a
loser.  These patchlets combined turned netperf TCP_RR cross-cpu vs
affine from big loser into a winner.

All of these are trivial, mostly axe murder, but cycles add up.

	-Mike

