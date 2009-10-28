Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZJ1FTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZJ1FTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZJ1FTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:19:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50112 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZJ1FTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:19:23 -0400
Date: Wed, 28 Oct 2009 06:19:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch v2] x86: reduce srat verbosity in the kernel log
Message-ID: <20091028051925.GL7744@basil.fritz.box>
References: <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <alpine.DEB.2.00.0910272129250.17260@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910272129250.17260@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/*
> +		 * If the bitmap cannot be listed in a buffer of length
> +		 * APICID_LIST_LEN, then it is suffixed with "...".
> +		 */
> +		len = bitmap_scnlistprintf(apicid_list, APICID_LIST_LEN,
> +					   apicid_map, MAX_LOCAL_APIC);
> +		pr_info("SRAT: PXM %u -> APIC {%s%s} -> Node %u\n",
> +			i, apicid_list,
> +			(len == APICID_LIST_LEN - 1) ? "..." : "",

Is the - 1 really correct? If scnlistprintf follows snprintf semantics then it would not
be and my understanding is it is supposed to.

Other than that it looks good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
