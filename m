Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXEQR7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXEQR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQR7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:59:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46816 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753949AbXEQR7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:59:31 -0400
Date: Thu, 17 May 2007 10:59:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179424335.2925.5.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705171057110.18085@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com> 
 <1179385718.27354.17.camel@twins>  <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
 <1179424335.2925.5.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Peter Zijlstra wrote:

> > I am weirdly confused by these patches. Among other things you told me 
> > that the performance does not matter since its never (or rarely) being 
> > used (why do it then?).
> 
> When we are very low on memory and do access the reserves by means of
> ALLOC_NO_WATERMARKS, we want to avoid processed that are not entitled to
> use such memory from running away with the little we have.

For me low memory conditions are node or zone specific and may be 
particular to certain allocation constraints. For some reason you have 
this simplified global picture in mind.

The other statement is weird. It is bad to fail allocation attempts, they 
may lead to a process being terminated. Memory should be reclaimed 
earlier to avoid these situations.

