Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZFXIaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZFXIaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZFXIaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:30:08 -0400
Received: from nox.protox.org ([88.191.38.29]:53269 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZFXIaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:30:06 -0400
Subject: Re: [PATCH] radeon: preallocate memory for command stream parsing
From: Jerome Glisse <glisse@freedesktop.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jerome Glisse <jglisse@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <84144f020906231252u5131ffbdk74f06f8a0f692cf9@mail.gmail.com>
References: <1245786367-2773-1-git-send-email-jglisse@redhat.com>
	 <84144f020906231252u5131ffbdk74f06f8a0f692cf9@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 10:29:01 +0200
Message-Id: <1245832141.2408.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 22:52 +0300, Pekka Enberg wrote:
> Hi Jerome,
> 
> On Tue, Jun 23, 2009 at 10:46 PM, Jerome Glisse<jglisse@redhat.com> wrote:
> > Command stream parsing is the most common operation and can
> > happen hundred of times per second, we don't want to allocate/free
> > memory each time this ioctl is call. This rework the ioctl
> > to avoid doing so by allocating temporary memory along the
> > ib pool.
> >
> > Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> 
> So how much does this help (i.e. where are the numbers)? I am bit
> surprised "hundred of times per second" is an issue for our slab
> allocators. Hmm?
> 

I didn't have real number but the vmap path was really slower,
quake3 fps goes from ~20 to ~40 on average when going from vmap
to preallocated. When using kmalloc i don't thing there was so
much performance hit. But i think the biggest hit was that in
previous code i asked for zeroed memory so i am pretty sure kernel
spend a bit of time clearing page. I reworked the code to avoid
needing cleared memory and so avoid memset, this is likely why
we get a performance boost.

Cheers,
Jerome

