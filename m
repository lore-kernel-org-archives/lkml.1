Return-Path: <linux-kernel-owner+w=401wt.eu-S1763936AbXGKPzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763936AbXGKPzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXGKPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:55:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:48393 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbXGKPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:55:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au
Subject: [PATCH 0/2][RFC] Scheduler preemption hooks, #2
Date: Wed, 11 Jul 2007 18:55:31 +0300
Message-Id: <11841693332609-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I redid the the scheduler preemption patches based on Rusty's feedback.
Things do look much cleaner this time around.

Changes:
- split into core and kvm parts
- incorporated Shaohua Li's fix
- each task now has a list of independently managed preemption hooks
- move preempt hook pointer to a hot cache line within task_struct

I haven't made kernel_fpu_begin()/kernel_fpu_end() preemptible as promised,
because (a) we need to find a place to put the fpu state, and (b) we should
get better performance by reusing cr0.ts anyway.

