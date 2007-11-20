Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbXKTR7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbXKTR7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXKTR7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:59:03 -0500
Received: from mga06.intel.com ([134.134.136.21]:43735 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751366AbXKTR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,442,1188802800"; 
   d="scan'208";a="235098630"
Date: Tue, 20 Nov 2007 09:59:26 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]intel-iommu-PMEN support
Message-ID: <20071120175926.GA18038@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071116223957.GA26796@linux.intel.com> <20071119163802.92cf1ac8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119163802.92cf1ac8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 04:38:02PM -0800, Andrew Morton wrote:
> On Fri, 16 Nov 2007 14:39:57 -0800
> mark gross <mgross@linux.intel.com> wrote:
> 
> > -#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
> > +#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
> 
> hm.  The logic in there looks screwy.

I didn't like it when they added the -1 to the above, but after looking
at it sideways for a while I convinced myself that it was ok.  so I
thought it be good to add the parentheses.

> 
> 
> static char *fault_reason_strings[] =
> {
> 	"Software",
> 	"Present bit in root entry is clear",
> 	"Present bit in context entry is clear",
> 	"Invalid context entry",
> 	"Access beyond MGAW",
> 	"PTE Write access is not set",
> 	"PTE Read access is not set",
> 	"Next page table ptr is invalid",
> 	"Root table address invalid",
> 	"Context table ptr is invalid",
> 	"non-zero reserved fields in RTP",
> 	"non-zero reserved fields in CTP",
> 	"non-zero reserved fields in PTE",
> 	"Unknown"
> };
> #define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
> 
> char *dmar_get_fault_reason(u8 fault_reason)
> {
> 	if (fault_reason >= MAX_FAULT_REASON_IDX)
> 		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
> 	else
> 		return fault_reason_strings[fault_reason];
> }
> 
> 
> so all invalid fault_reasons will cause us to display "non-zero reserved
> fields in PTE".

GAH!  Thats wrong.

I also don't like the use of >= here, its harder for me to parse in my
head than just >.


> 
> Why not just do
> 
> 	if (fault_reason >= ARRAY_SIZE(fault_reason_strings))
> 		return "Unknown";
> 	return fault_reason_strings[fault_reason];
> 
> ?

Why not indeed.  :)

> 
> (might as well make fault_reason_strings[] const, too).

Thats a good thing too.

I'll put together a patch this morning to address these think-ohs.

--mgross
