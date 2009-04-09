Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbZDIHU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbZDIHU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZDIHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:20:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41738 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZDIHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:20:15 -0400
Date: Thu, 9 Apr 2009 09:22:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
Message-ID: <20090409072236.GE14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407221542.91cd3c42.akpm@linux-foundation.org> <20090408061539.GD17934@one.firstfloor.org> <adafxgj6old.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adafxgj6old.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:29:34AM -0700, Roland Dreier wrote:
>  > [1] I didn't consider that one high priority since production
>  > systems with long uptime shouldn't have much free memory.
> 
> Surely there are windows after a big job exits where lots of memory
> might be free.  Not sure how big those windows are in practice but it
> does seem if a process using 128GB exits then it might take a while
> before that memory all gets used again.

Yes, it's definitely something to be fixed at some point.
Basically just needs a new entry point into the page_alloc
buddy allocator to unfree a page. The more tricky part
is actually finding a good injector design for testing for it,
there's no natural race free way to get a free page.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
