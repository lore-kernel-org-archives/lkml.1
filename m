Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZIJMjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZIJMjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZIJMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:39:34 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34936 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbZIJMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:39:34 -0400
Subject: Re: iwlagn: order 2 page allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <20090910123445.GC31153@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
	 <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
	 <1252570722.4876.23.camel@penberg-laptop>
	 <20090910123445.GC31153@csn.ul.ie>
Date: Thu, 10 Sep 2009 15:39:36 +0300
Message-Id: <1252586376.4876.29.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Thu, 2009-09-10 at 13:34 +0100, Mel Gorman wrote:
> > That's because it's a large allocation that's passed directly to the
> > page allocator. See kmalloc_large_node(), for example. 
> 
> Pants. Is there any chance that could be fixed so that allocation
> failures within SLUB get consistently reported?

Did you have something specific in mind? I am not sure it's worth it,
really.

The kmalloc_large() function is a static inline in
include/linux/slub_def.h that gets inlined nicely to a get_order() +
__get_free_pages() pair in the caller for production configs. I'm not
sure what we should print either. There's no known "object size" or
"buffer size" nor do we any of the variable order things or backing
struct kmem_cache_nodes.

			Pekka

