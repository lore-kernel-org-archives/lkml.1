Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZLVLFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZLVLFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZLVLFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:05:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZLVLFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:05:07 -0500
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
Date: Tue, 22 Dec 2009 12:03:24 +0100
Message-ID: <1261479804.4937.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
> > But as it stands I don't think its wise to replace the current workqueue
> > implementation with this, esp since there are known heavy CPU users
> > using it, nor have you addressed the queueing issue (or is that the
> > restoration of the single-queue workqueue?)
> 
> The queueing one is addressed and which CPU-heavy users are you
> talking about?  Workqueues have always been CPU-affine.  Not much
> changes for its users by cmwq. 

crypto for one (no clue what other bits we have atm, there might be some
async raid-n helper bits too, or whatever).

And yes that does change, the current design ensures we don't run more
than one crypto job per cpu, whereas with your stuff that can be
arbitrary many per cpu (up to some artificial limit of 127 or so).



