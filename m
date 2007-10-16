Return-Path: <linux-kernel-owner+w=401wt.eu-S1765256AbXJPITo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765256AbXJPITo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXJPITc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:19:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbXJPITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:19:30 -0400
Date: Tue, 16 Oct 2007 01:18:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Convert cpuinfo_x86 array to a per_cpu array
 v3
Message-Id: <20071016011827.91350174.akpm@linux-foundation.org>
In-Reply-To: <20070924210853.256462000@sgi.com>
References: <20070924210853.256462000@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 14:08:53 -0700 travis@sgi.com wrote:

> 
> v3: fix compile errors in arch-i386-allmodconfig build
> 
> v2: rebasing on 2.6.23-rc6-mm1
> 
> Analyzing various data structures when NR_CPU count is raised
> to 4096 shows the following arrays over 128k.  If the maximum
> number of cpus are not installed (about 99.99% of the time),
> then a large percentage of this memory is wasted.
> --
> 	151289856  CALNDATA  irq_desc
> 	135530496  RMDATATA  irq_cfg
> 	  3145728  CALNDATA  cpu_data
> 	  2101248  BSS       irq_lists
> 	  2097152  RMDATATA  cpu_sibling_map
> 	  2097152  RMDATATA  cpu_core_map
> 	  1575936  BSS       irq_2_pin
> 	  1050624  BSS       irq_timer_state
> 	   614400  INITDATA  early_node_map
> 	   525376  PERCPU    per_cpu__kstat
> 	   524608  DATA      unix_proto
> 	   524608  DATA      udpv6_prot
> 	   524608  DATA      udplitev6_prot
> 	   524608  DATA      udplite_prot
> 	   524608  DATA      udp_prot
> 	   524608  DATA      tcpv6_prot
> 	   524608  DATA      tcp_prot
> 	   524608  DATA      rawv6_prot
> 	   524608  DATA      raw_prot
> 	   524608  DATA      packet_proto
> 	   524608  DATA      netlink_proto
> 	   524288  BSS       cpu_devices
> 	   524288  BSS       boot_pageset
> 	   524288  CALNDATA  boot_cpu_pda
> 	   262144  RMDATATA  node_to_cpumask
> 	   262144  BSS       __log_buf
> 	   131072  BSS       entries
> 
> cpu_sibling_map and cpu_core_map have been taken care of in
> a prior patch.  This patch deals with the cpu_data array of
> cpuinfo_x86 structs.  The model that was used in sparc64
> architecture was adopted for x86.
> 

This has mysteriously started to oops on me, only on x86_64.

http://userweb.kernel.org/~akpm/config-x.txt
http://userweb.kernel.org/~akpm/dsc00001.jpg

which is a bit strange since this patch doesn't touch sched.c.  Maybe
there's something somewhere else in the -mm lineup which when combined with
this prevents it from oopsing, dunno.  I'll hold it back for now and will
see what happens.


