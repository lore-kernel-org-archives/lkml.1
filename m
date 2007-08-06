Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXHFTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXHFTbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbXHFTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:31:10 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:38285
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754329AbXHFTbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:31:09 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
Date: Mon, 6 Aug 2007 12:31:04 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <200708061035.18742.phillips@phunq.net> <1186424248.11797.66.camel@lappy>
In-Reply-To: <1186424248.11797.66.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061231.04982.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 11:17, Peter Zijlstra wrote:
> And how do we know a page was taken out of the reserves?

Why not return that in the low bit of the page address?  This is a 
little more cache efficient, does not leave that odd footprint in the 
page union and forces the caller to examine the 
alloc_pages(...P_MEMALLOC) return, making it harder to overlook the 
fact that it got a page out of reserve and forget to put one back 
later.

Regards,

Daniel
