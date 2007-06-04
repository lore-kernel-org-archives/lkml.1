Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXFDWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXFDWjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbXFDWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:39:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51359 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbXFDWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:39:09 -0400
Date: Mon, 4 Jun 2007 15:39:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <46646747.2080803@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> 
 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
 <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
 <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
 <46646747.2080803@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > That is another patchset. See
> > http://marc.info/?l=linux-kernel&w=2&r=1&s=DEVELKERNEL&q=b
> 
> Oh my, I am totally confused now.
> 
> First you fix kmalloc(0) to be legal and safe. And then you want to
> DEVEL_WARN_ON_ONCE when size is zero so people can fix their code?
> 
> I don't get it.

Sorry complex situation. Andrew wants the warnings, Linus wants the 
ZERO_SIZE_PTR. Not sure where we are going here.

> I thought we wanted to support kmalloc(0) so that as long as you don't
> dereference the pointer, it's all legal and good. Right? So we obviously
> should shut up the WARN_ON because if you do oops, you can clearly see that it
> happened at ZERO_SIZE_PTR and have a nice stack trace anyway...

Well so far we agreed to keep the warnings in at least till release data 
and I have not heard differently yet.

> Btw, if I am again missing something totally obvious, could you please be so
> kind to send me a batch of the same pills that the smart people take. I am all
> out.

Heheheh.... Mind boogling isnt it? Patch duplicity....

Seriously: Andrew/Linus could you make up your mind which way we are 
going here? 

I'd say lets drop the DEVELKERNEL stuff and the warnings and go with 
ZERO_SIZE_PTR. The DEVELKERNEL patch has the danger that subtle changes 
occur at release time that we have not anticipated.

