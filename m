Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYLaQIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYLaQIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYLaQIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:08:38 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:40438 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914AbYLaQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:08:37 -0500
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081231132738.GS496@one.firstfloor.org>
References: <20081230231152.10427.50620.stgit@hermosa.site>
	 <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site>
	 <20081231024609.GQ496@one.firstfloor.org>
	 <1230696664.3470.105.camel@hermosa.site>
	 <20081231132738.GS496@one.firstfloor.org>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Wed, 31 Dec 2008 09:08:26 -0700
Message-Id: <1230739706.3470.162.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 14:27 +0100, Andi Kleen wrote:
> > I say most because the assumption would be that we will be successful in
> > creating the new thread.  Not that bad an assumption I think.  Besides,
> 
> And that the memory read is not reordered (rmb()).
> 

At the risk of showing my b*tt here...  I'm not very clear on memory
barriers, is this necessary even inside a critical region?  (recall
we're protected by the spin lock).  If so, does the barrier go after the
read, or before?   (Thanks for not laughing, however grins are allowed)


> 
> Ok it probably needs some kind of feedback mechanism.
> 

Actually, I tend to think we need an entirely different approach to
flushing, please see my post to David Chinner which outlines some
thoughts.  Basically a flushing heuristic that takes into account the
characteristics of the various block devices.  


> > 
> > I was thinking about a patch that would go both directions - forward and
> > reverse depending upon, say, a bit in jiffies...  Certainly not perfect,
> > but a bit more fair.  
> 
> Better a real RNG. But such probalistic schemes unfortunately tend to drive
> benchmarkers crazy, that is why it is better to avoid them. 
> 

Nod, but that's ok. Having been one for several years I can truthfully
say that benchmarkers are a little crazy anyways... :-)


> I suppose you could just keep some state per fs to ensure fairness.
> 

Nod, this would be ideal.

-PWM

> -Andi

