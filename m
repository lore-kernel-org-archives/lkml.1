Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXCSV1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXCSV1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXCSV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:27:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20346 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964978AbXCSV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:27:29 -0400
To: "Bryan O'Sullivan" <bos@pathscale.com>
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14 of 33] IB/ipath - fix port sharing on powerpc
X-Message-Flag: Warning: May contain useful information
References: <62da2fb770b66310ac06.1173995098@iqa-25.internal.keyresearch.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Mar 2007 14:27:28 -0700
In-Reply-To: <62da2fb770b66310ac06.1173995098@iqa-25.internal.keyresearch.com> (Bryan O'Sullivan's message of "Thu, 15 Mar 2007 14:44:58 -0700")
Message-ID: <adaejnkncu7.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Mar 2007 21:27:28.0883 (UTC) FILETIME=[656ADC30:01C76A6D]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The port sharing feature mixed kernel virtual addresses as well as
 > physical addresses for the offset used to describe the mmap address to map
 > the InfiniPath hardware into user space.  This had a conflict on powerpc.
 > The new scheme converts it to a physical address so it doesn't conflict
 > with chip addresses and yet still fits in 40/44 bits so it isn't truncated
 > by 32-bit applications calling mmap64().

 > +/*
 > + * Convert kernel virtual addresses to physical addresses so they don't
 > + * potentially conflict with the chip addresses used as mmap offsets.
 > + * It doesn't really matter what mmap offset we use as long as we can
 > + * interpret it correctly. 
 > + */

 > +		paddr = page_to_pfn(page) << PAGE_SHIFT;
 > +
 > +	return paddr;

what guarantee is there that physical addresses fit into any number
of bits?  Couldn't I have a NUMA system or something that puts
physical memory starting at an offset of 1 << 48 or whatever?

 - R.
