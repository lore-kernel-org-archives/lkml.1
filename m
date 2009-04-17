Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZDQNuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZDQNuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbZDQNt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:49:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35405 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZDQNt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:49:57 -0400
Date: Fri, 17 Apr 2009 15:53:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [20/28] x86: MCE: Switch x86 machine check handler to Monarch election. II
Message-ID: <20090417135303.GP14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150803.1AF0C1D046E@basil.firstfloor.org> <49E866D3.1020003@jp.fujitsu.com> <20090417130944.GL14687@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417130944.GL14687@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 03:09:44PM +0200, Andi Kleen wrote:
> > > +
> > > +	/*
> > > +	 * Monarch starts executing now, the others wait.
> > > +	 */
> > > +	if (*order == 1) {
> > > +		atomic_set(&global_nwo, 0);
> > 
> > Monarch should clear global_nwo after all Subjects have read it.
> 
> The subjects don't care about the global nwo state, it only matters to the 
> Monarch who does the panic in mce_end(). The only exception would be timeout, 
> but in this case all the decisions are local only anyways.
> We ensure that all the subjects have written it first.

I thought some more about this and I think I was a little fast to dismiss
it due to the bank sharing heuristics. It's safer to indeed wait
for the subjects here too before clearing. I'll fix that up, thanks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
