Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbZAWRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbZAWRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 12:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbZAWRJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 12:09:52 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:28955 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753100AbZAWRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 12:09:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZPOP9fncSY66PhkAmAeTZ+JpQZB68n73KGwiKgUvdUhKyC6woBHN6ImsPYBHkWApzGU7Wo3RdTjvpquVIGrkugJsg9wbrd3Rydg7IYbsQ3A55u5jpxHzGOazhOaRkBNZqPZFAlT995pelSnxsICjNPoYgoWKgM7HCqKR+8CGMyo=  ;
X-YMail-OSG: UyZQLHUVM1kV0Ulh4EyD0oGXvb0rZQ6AKpfM5dz0CCQy.ZCijMtZJ1sP8JgeFsQKTBunqmaUYTEpMH5YON2uRZlBWYLGU.Tjd0rDaWZm5lwFWbXKnywaaxrjAHl.TGOYvE_1wjNSqgsSGEwI.4C_SkgN2FjvW998sau9mra.WqHkLGDEetQbuIUqy3dwtg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] SLQB slab allocator
Date: Sat, 24 Jan 2009 04:09:26 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114150900.GC25401@wotan.suse.de> <alpine.DEB.1.10.0901231042380.32253@qirst.com> <20090123161017.GC14517@wotan.suse.de>
In-Reply-To: <20090123161017.GC14517@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240409.27449.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 03:10:17 Nick Piggin wrote:
> On Fri, Jan 23, 2009 at 10:52:43AM -0500, Christoph Lameter wrote:
> > On Fri, 23 Jan 2009, Nick Piggin wrote:
> > > > Typically we traverse lists of objects that are in the same slab
> > > > cache.
> > >
> > > Very often that is not the case. And the price you pay for that is that
> > > you have to drain and switch freelists whenever you encounter an object
> > > that is not on the same page.
> >
> > SLUB can directly free an object to any slab page. "Queuing" on free via
> > the per cpu slab is only possible if the object came from that per cpu
> > slab. This is typically only the case for objects that were recently
> > allocated.
>
> Ah yes ok that's right. But then you don't get LIFO allocation
> behaviour for those cases.

And actually really this all just stems from conceptually in fact you
_do_ switch to a different queue (from the one being allocated from)
to free the object if it is on a different page. Because you have a
set of queues (a queue per-page). So freeing to a different queue is
where you lose LIFO property.

