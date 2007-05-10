Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbXEJXgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbXEJXgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXEJXf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:35:59 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:37685 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbXEJXf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:35:58 -0400
Date: Fri, 11 May 2007 08:35:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
Message-ID: <20070510233527.GA19597@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:00:08PM -0700, Christoph Lameter wrote:
> As far as I can tell there is only a single slab destructor left (there 
> is currently another in i386 but its going to go as soon as Andi merges 
> i386s support for quicklists).
> 
> I wonder how difficult it would be to remove it? If we have no need for 
> destructors anymore then maybe we could remove destructor support from the 
> slab allocators? There is no point in checking for destructor uses in 
> the slab allocators if there are none.
> 
> Or are there valid reason to keep them around? It seems they were mainly 
> used for list management which required them to take a spinlock. Taking a 
> spinlock in a destructor is a bit risky since the slab allocators may run 
> the destructors anytime they decide a slab is no longer needed.
> 
> Or do we want to continue support destructors? If so why?
> 
[snip pmb stuff]

I'll take a look at tidying up the PMB slab, getting rid of the dtor
shouldn't be terribly painful. I simply opted to do the list management
there since others were doing it for the PGD slab cache at the time that
was written.
