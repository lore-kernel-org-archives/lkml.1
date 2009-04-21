Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZDUHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZDUHNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZDUHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:13:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54738 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDUHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:13:06 -0400
Subject: Re: [PATCH 05/25] Break up the allocator entry point into fast and
 slow paths
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421150235.F12A.A69D9226@jp.fujitsu.com>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-6-git-send-email-mel@csn.ul.ie>
	 <20090421150235.F12A.A69D9226@jp.fujitsu.com>
Date: Tue, 21 Apr 2009 10:13:04 +0300
Message-Id: <1240297984.771.24.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, 2009-04-21 at 15:35 +0900, KOSAKI Motohiro wrote:
> > The core of the page allocator is one giant function which allocates memory
> > on the stack and makes calculations that may not be needed for every
> > allocation. This patch breaks up the allocator path into fast and slow
> > paths for clarity. Note the slow paths are still inlined but the entry is
> > marked unlikely.  If they were not inlined, it actally increases text size
> > to generate the as there is only one call site.
> 
> hmm..
> 
> this patch have few behavior change.
> please separate big cleanup patch and behavior patch.
> 
> I hope to make this patch non functional change. I'm not sure about these
> are your intentional change or not. it cause harder reviewing...

Agreed, splitting this patch into smaller chunks would make it easier to review.

			Pekka

