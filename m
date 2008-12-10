Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYLJCen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYLJCen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYLJCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:34:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYLJCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:34:32 -0500
Date: Tue, 9 Dec 2008 18:32:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Clement Calmels" <cboulte@gmail.com>,
       "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Pierre Peiffer" <peifferp@gmail.com>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Message-Id: <20081209183205.223f9b58.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970812091808r47e0cf07u8df2a9d2a27b783c@mail.gmail.com>
References: <20081203193901.715896543@mini.kroah.org>
	<20081203194725.GA8950@kroah.com>
	<20081203194906.GV8950@kroah.com>
	<21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
	<alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
	<21d7e9970812091643n7e3e4fe5g8e44030adfbababa@mail.gmail.com>
	<21d7e9970812091746u5b6e8594s8567007ec1e26bac@mail.gmail.com>
	<20081209180250.8d7301a7.akpm@linux-foundation.org>
	<21d7e9970812091808r47e0cf07u8df2a9d2a27b783c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 12:08:13 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> >> if my usage is illegal over just overlooked.
> >
> >
> > <greps for a while>
> >
> > I assume we're talking about drivers/gpu/drm/drm_stub.c:drm_minor_get_id()?
> >
> > I don't immediately see anything in the idr code which special-cases a
> > NULL caller pointer?
> >
> 
> Actually now that I'm starting to wrap my head around it I think it
> might be the fact that I call
> idr_get_new_above with 64, then later with 0. I'm not sure the new
> code is dealing with that case so
> well.
> 
> We don't do that in the standard kernel tree yet, so it explains why
> nobody's noticed, however the KMS
> changes introduce it, and we have those in f10.
> 
> http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/drm_stub.c;h=5ca132afa4f2e128999e319e44e31ad156e6ab74;hb=drm-next
> 
> is the drm_stub.c from drm-next that will trigger the issue.
> 
> Again I'm not sure if this is a legal use of idrs.
> 

Well nobody really maintains or owns the idr code, so there's nobody we
can ask about design intent.  Various people do hit-n-run attacks on it
when the need presents.

