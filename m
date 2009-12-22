Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbZLVLB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbZLVLB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZLVLBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:01:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZLVLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:01:55 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B3009DC.7020407@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>
	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 12:00:13 +0100
Message-ID: <1261479613.4937.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
> 
> >  4) didn't consider the RT needs
> 
> Can you be more specific?  What RT needs?  It's pretty difficult to
> tell when there's no in-kernel user and any shared worker pool would
> have pretty similar properties as cmwq. 

http://programming.kicks-ass.net/kernel-patches/rt-workqueue-prio/

Most of that passed over lkml too at various times and in various forms,
not eve sure that that is the last one, but its the one I found first.

Basically it boils down to letting the worklets run at the priority of
the enqueing task and boost current running works with the prio of the
highest pending work, including proper barrier support.

