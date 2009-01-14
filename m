Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZANCWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZANCWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZANCWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:22:22 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:17168 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbZANCWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:22:21 -0500
X-IronPort-AV: E=Sophos;i="4.37,261,1231113600"; 
   d="scan'208";a="27999938"
From: Roland Dreier <rdreier@cisco.com>
To: "James Kirin" <james.kirin40@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: memory beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y
References: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 Jan 2009 18:22:19 -0800
In-Reply-To: <baeb34bc0901131746n33cd536co331e32361df2fb72@mail.gmail.com>
	(James Kirin's message of "Wed, 14 Jan 2009 01:46:33 +0000")
Message-ID: <adaeiz6k4o4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 02:22:20.0324 (UTC) FILETIME=[ED740640:01C975EE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I am running kernel 2.6.28 on a computer with 8GB RAM. The BIOS
 > detects all 8GB, yet
 > 
 > jk@as12:~$ free
 >              total       used       free     shared    buffers     cached
 > Mem:       3622504     799696    2822808          0      90936     369604
 > -/+ buffers/cache:     339156    3283348
 > Swap:      6867776          0    6867776

The message in your kernel log:

[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4096MB of RAM.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1662 mtrr_trim_uncached_memory+0x283/0x2a4()

is a clue.  You might want to look for a BIOS update for your
motherboard.

 - R.
