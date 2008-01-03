Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYACR1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYACR1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYACR06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:26:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:59036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbYACR05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:26:57 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [0/8] GB pages (PDP1GB) support for the kernel direct mapping
Date: Thu,  3 Jan 2008 18:26:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit implement GB pages support for AMD Fam10h CPUs. This patchkit only
implements it for the kernel direct mapping for now; support for hugetlbfs is upcomming.

This allows to map the kernel direct mapping using 1GB TLBs instead of 2MB 
TLBs and get hopefully less TLB misses for the kernel.

The GB pages are only implemented for 64bit (because the CPU only implements
them for long mode) and also only for data pages (because Fam10h doesn't have GB ITLBs
and AMD recommends against running code in them) 

There is an option to turn them off (direct_gbpages=off), although I hope that
won't be needed.

Also includes one generic bug fix for clear_page_kernel.

-Andi
