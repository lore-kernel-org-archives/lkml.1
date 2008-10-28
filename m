Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYJ1VWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYJ1VWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYJ1VWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:22:20 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:1145 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYJ1VWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:22:18 -0400
X-IronPort-AV: E=Sophos;i="4.33,501,1220227200"; 
   d="scan'208";a="99467622"
From: Roland Dreier <rdreier@cisco.com>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws, npiggin@suse.de,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
	<49077E1A.5080105@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 28 Oct 2008 14:22:16 -0700
In-Reply-To: <49077E1A.5080105@redhat.com> (Avi Kivity's message of "Tue, 28
	Oct 2008 23:03:22 +0200")
Message-ID: <ada7i7so1o7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Oct 2008 21:22:16.0774 (UTC) FILETIME=[40B18E60:01C93943]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm guessing that the missing comment explains that this is
 > intentional, to trap buffer overflows?

Actually, speaking of comments, it's interesting that
__get_vm_area_node() -- which is called from vmalloc() -- does:

	/*
	 * We always allocate a guard page.
	 */
	size += PAGE_SIZE;

	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);

and alloc_vmap_area() adds another PAGE_SIZE, as the original email
pointed out:

		while (addr + size >= first->va_start && addr + size <= vend) {
			addr = ALIGN(first->va_end + PAGE_SIZE, align);

I wonder if the double padding is causing a problem when things get too
fragmented?

 - R.
