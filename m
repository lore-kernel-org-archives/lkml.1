Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYGQQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYGQQBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760613AbYGQQAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58875 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505AbYGQQAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:45 -0400
Message-Id: <20080717155724.897537670@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 11:57:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org
Subject: [patch 0/4] Port KVM-trace to tracepoints
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 17 Jul 2008 16:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a port of KVM-trace, currently using macros on top of the Linux Markers,
to tracepoints. Note that I cleaned up the instrumentation too, so stuff like

KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr,
  (u32)kvm_register_read(vcpu, reg),
  (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
  handler);

Sprinkled all across the KVM C code becomes :

trace_kvm_cr_write(vcpu, cr, reg);

Which looks much nicer, IMHO.

It applies on top of linux-next patch-v2.6.26-next-20080715.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
