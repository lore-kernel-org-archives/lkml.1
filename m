Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYIAItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYIAItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYIAItY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:49:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYIAItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:49:23 -0400
Date: Mon, 1 Sep 2008 10:52:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, paulmck@us.ibm.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Remove stop_machine during module load
Message-ID: <20080901085217.GA18288@one.firstfloor.org>
References: <20080829191734.GA28329@basil.nowhere.org> <200809011702.00956.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809011702.00956.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 05:02:00PM +1000, Rusty Russell wrote:
> On Saturday 30 August 2008 05:17:34 Andi Kleen wrote:
> > Remove stop_machine during module load
> >
> > module loading currently does a stop_machine on each module load to insert
> > the module into the global module lists.  Especially on larger systems this
> > can be quite expensive.
> 
> Thanks Andi, but doesn't this mean that we should be doing list_for_each_rcu 
> in all the kallsyms readers?

Yes I did that in v2. But only for the ones that don't hold modules_mutex
anyways. Also I found that print_modules() does not always disable 
preemption.

-Andi

-- 
ak@linux.intel.com
