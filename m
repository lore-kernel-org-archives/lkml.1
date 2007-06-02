Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXFBEbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXFBEbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXFBEbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:31:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbXFBEbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:31:34 -0400
Date: Fri, 1 Jun 2007 21:31:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-Id: <20070601213117.1178e8e0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<20070601204141.f84ad72f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 21:01:09 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > > On Fri, 1 Jun 2007 18:37:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > >
> > > +#define ZERO_SIZE_PTR ((void *)16)
> > 
> > Jeremy's point was a good one.  The kernel _does_ use address-comparison
> > to determine object-inequality in an unknown but non-zero number of places.
> > 
> > It is of course unlikely that this will occur in conjunction with zero-sized
> > objects, but who knows?
> 
> The zero sized objects are always the same and have the same content of 
> nothingness. So the kernel would find that they are the same which they 
> indeed are. Why could this be a problem?

They are different instances which happen to have the same length (zero).

But the code will incorrectly decide that they are the same instance.  It
might cause refcounting or accounting errors, for example.  I don't know - the
kernel's a big place.

I agree the risk is low, but if something _does_ blow up, it will do so subtly.

