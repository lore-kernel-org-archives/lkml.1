Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZAIKlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZAIKlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZAIKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:41:34 -0500
Received: from ozlabs.org ([203.10.76.45]:47401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZAIKld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:41:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
Date: Fri, 9 Jan 2009 21:40:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/9] Performance counters for POWER
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches extends Ingo and Thomas's performance
counter framework to add support for 64-bit POWER processors.
Currently I have the PPC970 family and POWER6 done.

The approach I have taken is to do the constraint checking and the
search through the space of alternative event codes as each group of
counters is added at the time a task is scheduled in.  That means we
are potentially doing the search several times in a row, with
interrupts disabled.  I think it will be OK since there are only a few
events that have alternatives (and not many of them), and the
constraint checking is fast since it is just simple integer
operations.  However, one of the things I plan to do is to instrument
that code to find out how long it takes in the worst case.  (If it
takes too long then I will need some major changes to the generic
code.)

This series is also available via git at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git

in the master branch.

Paul.
