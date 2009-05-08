Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbZEHOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbZEHOXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZEHOXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:23:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50775 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZEHOXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:23:01 -0400
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, riel@redhat.com, rientjes@google.com,
       xemul@openvz.org
In-Reply-To: <alpine.DEB.1.10.0905081018130.23875@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
	 <20090504131638.GJ4173@lenovo>
	 <alpine.DEB.1.10.0905040940490.9553@qirst.com>
	 <20090504115335.9bc08587.akpm@linux-foundation.org>
	 <20090504192117.GB31176@lenovo>
	 <20090504123453.d130a6cf.akpm@linux-foundation.org>
	 <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081018130.23875@qirst.com>
Date: Fri, 08 May 2009 17:23:00 +0300
Message-Id: <1241792580.28600.41.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Pekka Enberg wrote:
> > +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY | __GFP_NOMEMALLOC)

On Fri, 2009-05-08 at 10:20 -0400, Christoph Lameter wrote:
> So this means not retrying the allocation a couple of times? Not delving
> into reserve pools? Such behavior is good for a allocation that causes a
> panic if it fails?

If you do GFP_KERNEL|GFP_PANIC, we will cond_resched() and retry if we
made some progress. So yes, I think the behavior is good for early-boot
call-sites that can't really fail anyway.

			Pekka

