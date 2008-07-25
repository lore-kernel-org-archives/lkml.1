Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYGYVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYGYVMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYGYVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53607 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755741AbYGYVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:11:19 -0400
Message-Id: <20080725211117.586723000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 14:11:17 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86_64: Optimize percpu accesses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset provides the following:

  * x86_64: Cleanup setup_percpu by fixing some minor potential
    problems as well as add some debugging aids.

  * x86_64: Rebase per cpu variables to zero

    Rebase per cpu variables to zero in preparation for the following
    patch to fold the pda into the per cpu area.

  * x86_64: Fold pda into per cpu area

    Declare the pda as a per cpu variable. This will allow the per cpu
    variables to be accessible on the x86_64 using %gs as the base of
    the percpu areas for each cpu:

	%gs:per_cpu_xxxx

  * x86_64: Reference zero-based percpu variables offset from gs

    Actually implement the above operation for __get_cpu_var() and
    __put_cpu_var().  Since this is now a single instruction, we
    can remove the non-preemptible versions of x86_read_percpu()
    and x86_write_percpu().

Note that the following changes are NOT in this patchset as the plan now
seems to be that the common (to x86) variables that are in the pda should
be made individual per cpu variables, leaving only the stack canary in place.

  * x86_64: Replace cpu_pda ops with percpu ops
  * x86_64: Replace xxx_pda() operations with x86_xxx_percpu().
  * x86_64: Remove xxx_pda() operations
  * x86_64: Remove cpu_pda() macro

Based on linux-2.6.tip/master.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
