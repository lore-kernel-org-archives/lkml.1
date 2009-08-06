Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZHFLsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZHFLsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZHFLsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:48:39 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57166 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHFLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:48:38 -0400
Date: Thu, 6 Aug 2009 13:48:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, hidehiro.kawai.ez@hitachi.com,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] [11/19] HWPOISON: Refactor truncate to allow direct
 truncating of page v2
Message-ID: <20090806134830.4f3931d2@skybase>
In-Reply-To: <20090805141642.GB23992@wotan.suse.de>
References: <200908051136.682859934@firstfloor.org>
	<20090805093638.D3754B15D8@basil.firstfloor.org>
	<20090805102008.GB17190@wotan.suse.de>
	<20090805134607.GH11385@basil.fritz.box>
	<20090805140145.GB28563@wotan.suse.de>
	<20090805141001.GJ11385@basil.fritz.box>
	<20090805141642.GB23992@wotan.suse.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 16:16:42 +0200
Nick Piggin <npiggin@suse.de> wrote:

> On Wed, Aug 05, 2009 at 04:10:01PM +0200, Andi Kleen wrote:
> > > I haven't brought up the caller at this point, but IIRC you had
> > > the page locked and mapping confirmed at this point anyway so
> > > it would never be an error for your code.
> > > 
> > > Probably it would be nice to just force callers to verify the page.
> > > Normally IMO it is much nicer and clearer to do it at the time the
> > > page gets locked, unless there is good reason otherwise.
> > 
> > Ok. I think I'll just keep it as it is for now.
> > 
> > The only reason I added the error code was to make truncate_inode_page
> > fit into .error_remove_page, but then latter I did another wrapper
> > so it could be removed again. But it won't hurt to have it either.
> 
> OK, it's more of a cleanup/nit.
> 
> One question I had for the others (Andrew? other mm guys?) what is the
> feelings of merging this feature? Leaving aside exact implementation
> and just considering the high level design and cost/benefit. Last time
> there were some people objecting, so I wonder the situation now? So
> does anybody need more convincing? :)
> 
> Also I will just cc linux-arch. It would be interesting to know whether
> powerpc, ia64, or s390 or others would be interested to use this feature?

This is not relevant for s390, as current machines do transparent memory
sparing if a memory module goes bad. Really old machines reported bad
memory to the OS by means of a machine check (storage error uncorrected
and storage error corrected). I have never seen this happen, the level
below the OS deals with these errors for us.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

