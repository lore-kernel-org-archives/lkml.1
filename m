Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXFFRGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXFFRGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXFFRGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:06:41 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:37620 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751005AbXFFRGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:06:40 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Mel Gorman <mel@skynet.ie>, Cedric Le Goater <clg@fr.ibm.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, aaw@google.com
In-Reply-To: <20070606163538.GN6909@holomorphy.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <4666ABD4.8050402@fr.ibm.com> <4666D050.7010603@googlemail.com>
	 <4666DA55.5090405@fr.ibm.com> <20070606162649.GA9932@skynet.ie>
	 <20070606163538.GN6909@holomorphy.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 19:06:20 +0200
Message-Id: <1181149580.5676.25.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 09:35 -0700, William Lee Irwin III wrote:
> On Wed, Jun 06, 2007 at 05:26:49PM +0100, Mel Gorman wrote:
> > I do not believe this is Nick's problem. I encountered the same issue and
> > the bisect ended up here;
> > # BISECT HERE
> > mm-variable-length-argument-support.patch
> > mm-variable-length-argument-support-fix.patch
> > # BISECT BAD
> > Reverting those two patches boots ok on my standalone x86 laptop.
> > Patch authors cc'd. I have not read the patches yet to see what might
> > be the problem.
> 
> I found this a while ago and peterz already has a tentative fix for it at
> http://programming.kicks-ass.net/kernel-patches/max_arg_pages/move_anon_vma.patch
> I'm sure he himself will chime in with more/better code when he returns.

Ah, yes indeed. We were discussing wether it would be better to update
page->index (as this patch does) or not change vma->vm_pgoff. Bill
argued that the latter would be safe, it would just limit the merge
capabilities of the anon vma (and the stack rarely, if ever, merges
anyway).

I myself an not quite sure on the effects of ->vm_pgoff of anon vmas
yet.

