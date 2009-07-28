Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZG1Gf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZG1Gf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 02:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZG1Gf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 02:35:27 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42857 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG1Gf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 02:35:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19054.33655.297932.261580@cargo.ozlabs.ibm.com>
Date: Tue, 28 Jul 2009 14:49:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: NMI between switch_mm and switch_to
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben H. suggested there might be a problem if we get a PMU interrupt
and try to do a stack trace of userspace in the interval between when
we call switch_mm() from sched.c:context_switch() and when we call
switch_to().  If we get an NMI in that interval and do a stack trace
of userspace, we'll see the registers of the old task but when we peek
at user addresses we'll see the memory image for the new task, so the
stack trace we get will be completely bogus.

Is this in fact also a problem on x86, or is there some subtle reason
why it can't happen there?

Paul.
