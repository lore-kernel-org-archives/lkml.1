Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbZENDwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbZENDwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZENDwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:52:03 -0400
Received: from mga10.intel.com ([192.55.52.92]:3649 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754664AbZENDwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:52:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,192,1241420400"; 
   d="scan'208";a="690271296"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to 64 bits in X86_64
Date: Thu, 14 May 2009 11:52:28 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "linux-mm" <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>
References: <1242202647-32446-1-git-send-email-sheng@linux.intel.com> <4A0AFB7D.2080105@zytor.com> <4A0B036B.7000107@zytor.com>
In-Reply-To: <4A0B036B.7000107@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141152.29378.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009 01:29:15 H. Peter Anvin wrote:
> H. Peter Anvin wrote:
> > H. Peter Anvin wrote:
> >> Sheng Yang wrote:
> >>> This fix 44/45 bit width memory can't boot up issue. The reason is
> >>> free_bootmem_node()->mark_bootmem_node()->__free() use
> >>> test_and_clean_bit() to clean node_bootmem_map, but for 44bits width
> >>> address, the idx set bit 31 (43 - 12), which consider as a nagetive
> >>> value for bts.
> >>>
> >>> This patch applied to tip/mm.
> >>
> >> Hi Sheng,
> >>
> >> Could you try the attached patch instead?
> >
> > Sorry, wrong patch entirely... here is the right one.
>
> This time, for real?  Sheesh.  I'm having a morning, apparently.
>
> 	-hpa

Yeah, this one also works well(lightly tested). :)

But one thing should be noticed that, bit ops recognized the input as signed. 
According to SDM 2A 3.1.1.7 Operation Section, Bit(BitBase, BitOffset) can 
accept BitOffset as negative value, then search backward... Well, I indeed 
don't know when we need this, but I think keep signed here should be better...

-- 
regards
Yang, Sheng 
