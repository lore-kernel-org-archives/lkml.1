Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYLJRjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYLJRjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYLJRje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:39:34 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:33156 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYLJRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:39:34 -0500
Message-ID: <493FFD6F.2080209@colorfullife.com>
Date: Wed, 10 Dec 2008 18:33:35 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       Clement Calmels <cboulte@gmail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
References: <20081203193901.715896543@mini.kroah.org> <20081203194725.GA8950@kroah.com> <20081203194906.GV8950@kroah.com> <21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com> <alpine.LFD.2.00.0812091447230.3340@localhost.localdomain> <21d7e9970812091643n7e3e4fe5g8e44030adfbababa@mail.gmail.com> <21d7e9970812091746u5b6e8594s8567007ec1e26bac@mail.gmail.com> <20081209180250.8d7301a7.akpm@linux-foundation.org> <21d7e9970812091808r47e0cf07u8df2a9d2a27b783c@mail.gmail.com>
In-Reply-To: <21d7e9970812091808r47e0cf07u8df2a9d2a27b783c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> Actually now that I'm starting to wrap my head around it I think it
> might be the fact that I call
> idr_get_new_above with 64, then later with 0. I'm not sure the new
> code is dealing with that case so
> well.
>   
Yes, that's it.
When idr_get_new_above(,,64,) is called, the idr code creates a tree 
with 2 layers, without the entry 0 in layer 1.
This was special-cased [without comments], I missed it.

I've just send you a patch, could you try it?
It passes self tests [including idr_get_new_above and idr_replace].

--
    Manfred
