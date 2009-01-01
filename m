Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZAABfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZAABfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 20:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZAABfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 20:35:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40871 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZAABfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 20:35:00 -0500
Date: Thu, 1 Jan 2009 02:48:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
Message-ID: <20090101014825.GV496@one.firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site> <20081231024609.GQ496@one.firstfloor.org> <1230696664.3470.105.camel@hermosa.site> <20081231132738.GS496@one.firstfloor.org> <1230739706.3470.162.camel@hermosa.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230739706.3470.162.camel@hermosa.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 09:08:26AM -0700, Peter W. Morreale wrote:
> On Wed, 2008-12-31 at 14:27 +0100, Andi Kleen wrote:
> > > I say most because the assumption would be that we will be successful in
> > > creating the new thread.  Not that bad an assumption I think.  Besides,
> > 
> > And that the memory read is not reordered (rmb()).
> > 
> 
> At the risk of showing my b*tt here...  I'm not very clear on memory
> barriers, is this necessary even inside a critical region?  (recall
> we're protected by the spin lock).

You're right the implied barriers in the spinlock are probably enough.
Never mind.

> If so, does the barrier go after the
> read, or before?   (Thanks for not laughing, however grins are allowed)

Before.

BTW on x86 it's a nop either way, but not on all other architectures.

> 
> 
> > 
> > Ok it probably needs some kind of feedback mechanism.
> > 
> 
> Actually, I tend to think we need an entirely different approach to
> flushing, please see my post to David Chinner which outlines some
> thoughts.  Basically a flushing heuristic that takes into account the
> characteristics of the various block devices.  

Ideally discovered at runtime (e.g. by watching queue lengths/service
times etc.) though. Otherwise the kernel would need to have knowledge
about the properties of all kinds of devices.

-Andi
-- 
ak@linux.intel.com
