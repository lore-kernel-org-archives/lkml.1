Return-Path: <linux-kernel-owner+w=401wt.eu-S1765009AbZLQRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765009AbZLQRUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764973AbZLQRUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:20:18 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49866 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764967AbZLQRUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:20:16 -0500
Date: Thu, 17 Dec 2009 22:50:10 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [Patch 0/1] Enable user-space breakpoint requests using PID
Message-ID: <20091217172010.GB5457@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a patch that enables user-space breakpoints to be
requested using the 'pid' of a process.

The breakpoint request, thus received, is active over all threads of
the process (all task_structs having the same 'tgid') and on any new
threads that get spawned eventually.

Given that the 'pid' of a process is more visible (than its
task_struct), such an interface is expected to be useful to
debuggers/tracers (such as SystemTap).

The patch is based on commit 7818b3d0fc68f5c2a85fed86d9fa37131c5a3068 of
-tip tree. It has been tested with a hack to the -tip kernel code (that
comments out all references to event->filp) due to a bug in the
perf-events code (reported here 20091217170309.GA5457@in.ibm.com).

Thanks,
K.Prasad

