Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYCYSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYCYSYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYCYSYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:24:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34602
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757349AbYCYSYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:24:05 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] Corrections to Documentation/rbtree.txt
Date: Tue, 25 Mar 2008 13:24:08 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <47E282F5.6090703@mev.co.uk> <200803201339.18618.rob@landley.net> <47E8DBBE.4030607@mev.co.uk>
In-Reply-To: <47E8DBBE.4030607@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803251324.08769.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008 06:02:22 Ian Abbott wrote:
> On 20/03/08 18:39, Rob Landley wrote:
> > On Thursday 20 March 2008 10:29:57 Ian Abbott wrote:
> >> From: Ian Abbott <abbotti@mev.co.uk>
> >>
> >> The description of the rb_entry() macro in Documentation/rbtree.txt
> >> seems incorrect. This patch improves it (hopefully).  Also I changed the
> >> example code to call the previous 'my_search()' example instead of an
> >> undefined 'mysearch()'.
> >
> > I have no objection to the patch (and the my_search thing seems like an
> > obvious typo), but is there a reason to prefer rb_entry() rather than
> > container_of()?  If so, the rationale might be a good thing to add to the
> > documentation...
>
> I don't know the rationale, but all the code I can see uses rb_entry()
> and not container_of().

Except container_of() works, which is a nice thing to know, and it already 
mentions rb_entry() as another way to do it.  If someone could explain _why_ 
to use one over the other, that would be a good thing to add.

> The only rationale I can think of is that it 
> abstracts away from the nodes being embedded in the data a little bit.

If I wanted abstraction for its own sake I'd be using C++ to implement a 
microkernel.  I would also be certifiably insane.

> (But not by much - in particular, an implementation of rb trees that
> stored data in the node explicitly would only need a single parameter in
> its rb_entry() accessor.  I like the approach taken in
> include/linux/elevator.h that uses the rb_entry() macro to create a
> specialized accessor macro (rb_entry_rq()) with a single parameter.

And this can't be done with container_of()?

Again, I don't care much either way, I just want to know what the point is of 
choosing one over the other that makes changing what's there worth bothering 
with.  You're changing the documentation to hide the fact that rb_entry() is 
basically another name for container_of(), and this is supposed to be an 
improvement?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
