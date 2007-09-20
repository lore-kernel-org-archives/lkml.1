Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbXITVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbXITVa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXITVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:30:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40951 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbXITVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:30:05 -0400
Message-Id: <20070920213004.527735000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Sep 2007 14:30:04 -0700
From: travis@sgi.com
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86: Reduce Memory Usage for large CPU count systems v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


v2: rebasing on 2.6.23-rc6-mm1

Analyzing various data structures when NR_CPU count is raised
to 4096 shows the following arrays over 128k.  If the maximum
number of cpus are not installed (about 99.99% of the time),
then a large percentage of this memory is wasted.
--
	151289856  CALNDATA  irq_desc
	135530496  RMDATATA  irq_cfg
	  3145728  CALNDATA  cpu_data
	  2101248  BSS       irq_lists
	  2097152  RMDATATA  cpu_sibling_map
	  2097152  RMDATATA  cpu_core_map
	  1575936  BSS       irq_2_pin
	  1050624  BSS       irq_timer_state
	   614400  INITDATA  early_node_map
	   525376  PERCPU    per_cpu__kstat
	   524608  DATA      unix_proto
	   524608  DATA      udpv6_prot
	   524608  DATA      udplitev6_prot
	   524608  DATA      udplite_prot
	   524608  DATA      udp_prot
	   524608  DATA      tcpv6_prot
	   524608  DATA      tcp_prot
	   524608  DATA      rawv6_prot
	   524608  DATA      raw_prot
	   524608  DATA      packet_proto
	   524608  DATA      netlink_proto
	   524288  BSS       cpu_devices
	   524288  BSS       boot_pageset
	   524288  CALNDATA  boot_cpu_pda
	   262144  RMDATATA  node_to_cpumask
	   262144  BSS       __log_buf
	   131072  BSS       entries

cpu_sibling_map and cpu_core_map have been taken care of in
a prior patch.  This patch deals with the cpu_data array of
cpuinfo_x86 structs.  The model that was used in sparc64
architecture was adopted for x86.

Obviously, the IRQ arrays are of greater importance for
size reduction.  Any suggestions, or threads I should read
are gratefully accecpted... ;-)

-- 
