Return-Path: <linux-kernel-owner+w=401wt.eu-S1759617AbZCOTeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617AbZCOTeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758271AbZCOTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:31:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56469 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbZCOTbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:31:51 -0400
Message-Id: <20090315190340.229569867@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 15 Mar 2009 15:03:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC patch 00/21] TIF_KERNEL_TRACE thread flags
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 15 Mar 2009 19:30:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the implementatino of TIF_KERNEL_TRACE thread flags I did in the LTTng
tree. Basically, it offers :

- Setting a per-thread flag for _all_ threads to enable system-wide syscall
  tracing.
- No performance impact when disabled, no need to stop threads upon
  activation/deactivation (does not add latency to userspace threads upon
  activation).

The most tricky bits are in the x86_64 architecture, because its entry_64.S
code does not expect the thread flags to be changed concurrently while the
thread is running. I modified entry_64.S so that the architecture does not
suffer of any performance impact when syscall audit or secure computing is
enabled, but tests for the TIF_KERNEL_TRACE flag upon return to userspace too.

Given this looks very much like what Frederic is currently doing, I think it's
good to post it for comments.

utrace tracehooks could potentially make this patchset obsolete, but I an not
yet convinced that utrace offers the same low-latency guarantees as this code.

It applies on top of kernel 2.6.29-rc7.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
