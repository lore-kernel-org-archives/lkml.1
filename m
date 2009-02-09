Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZBIOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZBIOvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbZBIOvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:51:06 -0500
Received: from xi.wantstofly.org ([80.101.37.227]:46204 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZBIOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:51:05 -0500
Date: Mon, 9 Feb 2009 15:50:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: /proc/profile broken on UP machines in 2.6.29-rc3
Message-ID: <20090209145058.GY13433@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm about 130k emails behind on my linux-kernel@ subscription, so I'm
not entirely sure whether this has been reported, but it seems that
profiling is broken on !CONFIG_SMP builds in 2.6.29-rc3.

It appears that since this commit:

	commit c309b917cab55799ea489d7b5f1b77025d9f8462
	Author: Rusty Russell <rusty@rustcorp.com.au>
	Date:   Thu Jan 1 10:12:27 2009 +1030

	    cpumask: convert kernel/profile.c

there's no longer anything that sets any bits in prof_cpu_mask on
UP systems at all (the default was to assign CPU_MASK_ALL, and
profile_cpu_callback() which clears/sets bits at run time is only
built and registered on SMP builds), so the cpumask_test_cpu()
test in profile_tick() always fails, and no samples are ever counted.
