Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbXJWRFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbXJWRFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbXJWRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:05 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35016
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752511AbXJWRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:03 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 00/13] Balance RT tasks v5
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:50:23 -0400
Message-ID: <20071023164156.5536.95573.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 5 of the patch series against 23-rt1.

There have been numerous fixes/tweaks since v4, though we still are based on
the global rto_cpumask logic instead of Steve/Ingo's cpuset logic.  Otherwise,
it's in pretty good shape.

Without the series applied, the following test will fail:

ftp://ftp.novell.com/dev/ghaskins/preempt-test-latest.tar.bz2

After it is applied, it will pass.

NOTE: it appears that the series also introduces wake-latency spikes that
are not present in the baseline code, so this is still "RFC" quality.
However, the baseline scheduler also violates priority order, so its hard to
determine if the numbers translate apples to apples.  These issues are still
under investigation, but I am sharing the series now so that Steven Rostedt
and Darren Hart can have access to my current tree.  The issues appear to be
caused by some other strange scheduling decisions (such as running the idle
thread while we are busy).  TBD 
