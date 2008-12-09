Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYLIRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYLIRxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYLIRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:53:40 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48253 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbYLIRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:53:39 -0500
Message-Id: <20081209174949.355669577@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Dec 2008 18:49:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sched: re-add removed arch_update_cpu_topology call
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_reinit_sched_domains used to call arch_update_cpu_topology
via arch_init_sched_domains. This call got lost with
e761b7725234276a802322549cee5255305a0930 ("cpu hotplug, sched: Introduce
cpu_active_map and redo sched domain managment (take 2)".

So we might end up with outdated and missing cpus in the cpu core
maps (architecture used to call arch_reinit_sched_domains if cpu
topology changed).

This patch set changes arch_update_cpu_topology so that it can indicate
if the cpu topology changed and adds a call to arch_update_cpu_topology
in partition_sched_domains which gets called whenever scheduling domains
get updated. Which is what is supposed to happen when cpu topology changes.
