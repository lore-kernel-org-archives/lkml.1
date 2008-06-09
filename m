Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYFIVi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYFIVi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYFIViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:38:21 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:50770 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYFIViU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:38:20 -0400
X-IronPort-AV: E=Sophos;i="4.27,614,1204531200"; 
   d="scan'208";a="77771399"
From: Roland Dreier <rdreier@cisco.com>
To: steiner@sgi.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 03/11] GRU Driver - driver internal header files
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080609211045.488884093@attica.americas.sgi.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 14:38:18 -0700
In-Reply-To: <20080609211045.488884093@attica.americas.sgi.com>
	(steiner@sgi.com's message of "Mon, 09 Jun 2008 16:10:31 -0500")
Message-ID: <adak5gy70hh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 21:38:18.0936 (UTC) FILETIME=[21F11380:01C8CA79]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +/*
 > + * Structure used to pass TLB flush parameters to the driver
 > + */
 > +struct gru_flush_tlb_req {
 > +	unsigned long	gseg;
 > +	unsigned long	vaddr;
 > +	size_t		len;
 > +};

This and other data structures you pass into the kernel via ioctl() are
not 32/64 clean.  So a 32-bit process (which can easily run on a 64-bit
x86-64 kernel) will end up sending garbage to the kernel.
