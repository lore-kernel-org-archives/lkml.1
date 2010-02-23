Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0BWBq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:46:56 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40600 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0BWBqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:46:55 -0500
Date: Mon, 22 Feb 2010 17:46:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, jkacur@redhat.com
Subject: [PATCH RFC] rcu: RCU CPU stall patches backported to 2.6.33-rc8
Message-ID: <20100223014654.GA3404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This set backports a couple of RCU CPU stall detection patches from the
earlier series (http://lkml.org/lkml/2010/2/22/384) to 2.6.33-rc8 to
help track down some NMI issues.

These two patches fix an embarrassing deadlock that can affect
TREE_PREEMPT_RCU and add additional per-task output when tasks stall the
RCU grace period.

 b/kernel/rcutree.c        |    2 +
 b/kernel/rcutree.h        |    1 
 b/kernel/rcutree_plugin.h |    4 ---
 b/lib/Kconfig.debug       |   13 ++++++++++-
 kernel/rcutree.c          |    4 +++
 kernel/rcutree_plugin.h   |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 71 insertions(+), 5 deletions(-)
