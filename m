Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYGXN65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYGXN65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYGXN6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:58:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYGXN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:58:45 -0400
Subject: Re: Odd swapping issue
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafal Wijata (NULL)" <devnull@wijata.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48888770.70702@wijata.com>
References: <488761F0.4040906@wijata.com>  <48888770.70702@wijata.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 15:58:51 +0200
Message-Id: <1216907931.7257.333.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 15:45 +0200, Rafal Wijata (NULL) wrote:
> OK, things are little more clear now I suppose.
> 
> I tried (just for fun) echo 8 > /proc/sys/vm/nr_hugepages
> and it happened again, and no hugepages were allocated of course.
> 
> But this brought the following to my mind.
> 
> Since it's nfs server/client, and the nfs is rather heavily utilized(at 
> least sometimes), maybe nfsd tasks were unable to find long enough lowmem 
> chunk. How can we get such ram? By sweeping pages out to swap, isn't it?
> 
> Now the question is, if Linux actually has such feature like blind swapping 
> out if lowmem is too fragmented to find requested size?
> Can anybody confirm or negate?

Well, not blind - we have lumpy reclaim that tries to focus on the right
spot for large order allocations. However there are a myrad of
conditions that can make it impossible to reclaim certain pages,
therefore defeating this strategy.

> Next, I was thinking then I could run 64bit system, but I don't want to 
> reinstall it. Anybody knows if it's possible to have installed 32bit OS, but 
> run 64bit kernel alone(no 64bit glibc or anything else)?

Yes running as I type ;-)

