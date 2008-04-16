Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbYDPUhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbYDPUhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYDPUhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:37:32 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:39391 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYDPUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:37:31 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
References: <20080416202338.GA6007@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Apr 2008 13:37:30 -0700
In-Reply-To: <20080416202338.GA6007@elte.hu> (Ingo Molnar's message of "Wed,
	16 Apr 2008 22:23:38 +0200")
Message-ID: <adar6d5ilit.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2008 20:37:30.0654 (UTC) FILETIME=[B116EBE0:01C8A001]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  - PAT support - first step towards phasing out MTRR's for cache 
 >    attribute control

I just grabbed your tree and I see that there is no
pgprot_writecombine() for x86.  I see that pci_mmap_page_range() handles
write combining but there's no way for a PCI driver to allow userspace
to mmap() part of a BAR with WC enabled.  Doing this gives a big
performance boost for running low-latency apps on InfiniBand hardware
driven by the mlx4 driver (look for the FIXME about it in
drivers/infiniband/hw/mlx4/main.c).  Are there any plans to handle this
somehow?

Thanks,
  Roland
