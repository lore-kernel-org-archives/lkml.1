Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXCIRrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXCIRrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXCIRq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:46:59 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:38740 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbXCIRq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:46:58 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Date: Fri, 9 Mar 2007 18:47:06 +0100
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI> <200703091213.35691.dada1@cosmosbay.com> <20070309161113.GM6209@kvack.org>
In-Reply-To: <20070309161113.GM6209@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091847.06604.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 17:11, Benjamin LaHaise wrote:
> On Fri, Mar 09, 2007 at 12:13:35PM +0100, Eric Dumazet wrote:
> > Then just drop the fget_light() 'optimisation' and always take a
> > reference (atomic on f_count) regardless of single-thread or not. Instead
> > of dirtying f_light, just do the straightforward thing and be with it.
> >
> > (that is : fget_light() = fget() = no more keeping fput_needed
> > everywhere, and convoluted things in some dark sides of the kernel.
>
> And it makes things rather slower for a lot of single threaded applications
> on modern systems.  Yes, fget_light can be done much more cleanly, but
> please don't go around ripping out optimizations just because.

Sure. But I apparently was the only guy to react to the f_light horror story.

And it seems a solution was found, after some mail exchanges.

In French we have this expression : "Precher le faux pour savoir le vrai"

You could translate to "make false statements in order to discover the truth" 
or "to tell a lie in order to get at the truth" or maybe "playing the devil's 
advocate", but really the French one is better :)

