Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFYHES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFYHES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZFYHEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:04:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44962 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZFYHEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:04:07 -0400
Subject: Re: [PATCH] radeon: preallocate memory for command stream parsing
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: Jerome Glisse <jglisse@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <1245832141.2408.4.camel@localhost>
References: <1245786367-2773-1-git-send-email-jglisse@redhat.com>
	 <84144f020906231252u5131ffbdk74f06f8a0f692cf9@mail.gmail.com>
	 <1245832141.2408.4.camel@localhost>
Date: Thu, 25 Jun 2009 10:04:07 +0300
Message-Id: <1245913447.2018.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome,

On Tue, 2009-06-23 at 22:52 +0300, Pekka Enberg wrote:
> > On Tue, Jun 23, 2009 at 10:46 PM, Jerome Glisse<jglisse@redhat.com> wrote:
> > > Command stream parsing is the most common operation and can
> > > happen hundred of times per second, we don't want to allocate/free
> > > memory each time this ioctl is call. This rework the ioctl
> > > to avoid doing so by allocating temporary memory along the
> > > ib pool.
> > >
> > > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> > 
> > So how much does this help (i.e. where are the numbers)? I am bit
> > surprised "hundred of times per second" is an issue for our slab
> > allocators. Hmm?

On Wed, 2009-06-24 at 10:29 +0200, Jerome Glisse wrote:
> I didn't have real number but the vmap path was really slower,
> quake3 fps goes from ~20 to ~40 on average when going from vmap
> to preallocated. When using kmalloc i don't thing there was so
> much performance hit. But i think the biggest hit was that in
> previous code i asked for zeroed memory so i am pretty sure kernel
> spend a bit of time clearing page. I reworked the code to avoid
> needing cleared memory and so avoid memset, this is likely why
> we get a performance boost.

OK. If kmalloc() (without memset) really was too slow for your case, I'd
be interested in looking at it in more detail. I'm not completely
convinced the memory pool is needed here but I'm not a DRM expert so I'm
not NAK'ing this either...

			Pekka

