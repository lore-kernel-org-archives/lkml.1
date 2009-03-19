Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbZCSXr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbZCSXr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZCSXrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:47:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39357 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZCSXrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:47:49 -0400
Date: Fri, 20 Mar 2009 05:17:34 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch 00/11] Hardware Breakpoint Interfaces - v5
Message-ID: <20090319234734.GA10517@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please find the new set of patches that implement Hardware
breakpoint interfaces for kernel- and user-space, an ftrace plugin using these
interfaces to trace memory accesses over kernel symbols and a demonstrative
example.

While a previous version of these patches was posted
here: http://lkml.org/lkml/2009/3/7/23 and generated substantial amount of
discussions over LKML, a summary of proposed changes to the patchset was posted
here: http://lkml.org/lkml/2009/3/13/381.

In short, the infrastructure has been changed to provide interfaces to use
Hardware Breakpoint (or Watchpoint) registers on a first-come first-serve basis
(without over-committing resources). The serviced-requests are maintained in an
array of pointers to the register's datastructure. Requests from kernel-space
will be serviced in decreasing order of register numbers (starting from
HB_NUM - 1).

The ksym_tracer ftrace plugin now also contains a startup self-test and support
for showing aggregate counters (through ftrace's histogram infrastructure).

Kindly let me know if the new patchset addresses the concerns of the community
and is deemed fit for inclusion in -tip tree. The patchset is based on commit
62f84ea922bd60803e446153ea99ce5d7245d6f9 of -tip tree.

Thanks,
K.Prasad

