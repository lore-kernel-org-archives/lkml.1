Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYJCIVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYJCIVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYJCIVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:21:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbYJCIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:21:24 -0400
Date: Fri, 3 Oct 2008 01:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
Message-Id: <20081003012003.f1f84937.akpm@linux-foundation.org>
In-Reply-To: <1223019811.30285.12.camel@penberg-laptop>
References: <20080929193500.470295078@quilx.com>
	<20080929193516.278278446@quilx.com>
	<20081003003342.4d592c1f.akpm@linux-foundation.org>
	<1223019811.30285.12.camel@penberg-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Oct 2008 10:43:31 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
> 
> On Fri, 2008-10-03 at 00:33 -0700, Andrew Morton wrote:
> > > +static void set_map(int start, int length)
> > > +{
> > > +	while (length-- > 0)
> > > +		__set_bit(start++, cpu_alloc_map);
> > > +}
> > 
> > Can we use bitmap_fill() here?
> 
> But bitmap_fill() assumes that the starting offset is aligned to
> unsigned long (which is not the case here), doesn't it?

umm, yeah, the whole bitmap interface is busted from that POV.

> ___On Fri, 2008-10-03 at 00:33 -0700, Andrew Morton wrote:
> > But I'd have though that it would be possible to only allocate the
> > storage for online CPUs.  That would be a pretty significant win for
> > some system configurations?
> 
> Maybe, but then you'd have to deal with CPU hotplug... iik.

Of course.
