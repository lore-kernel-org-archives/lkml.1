Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXAaXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXAaXRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160994AbXAaXRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:17:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58318 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030202AbXAaXRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:17:49 -0500
Date: Wed, 31 Jan 2007 15:13:38 -0800
From: Andrew Morton <akpm@osdl.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Pawe=C5?= Sikora <pluto@agmk.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <ak@suse.de>
Subject: Re: Linux 2.6.20-rc7
Message-Id: <20070131151338.04bd200a.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	<45C05150.6000802@agmk.net>
	<Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 08:04:29 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 31 Jan 2007, Pawe__ Sikora wrote:
> > 
> > The 2.6.20-rcX have the same nasty bug as 2.6.19.x.
> > 
> > [ an oops inside kmem_get_pages ]
> > http://bugzilla.kernel.org/show_bug.cgi?id=7889
> 
> Pabel, can you detail more exactly which kernels don't work, and which do?
> 
> >From bugzilla:
> 
>  - 2.6.18.x does work
>  - 2.6.19.2 doesn't work.
>  - what about plain 2.6.19?
>  - can you please test some of the 2.6.19-rcX kernels? Especially 
>    2.6.19-rc1 would be good to test.
> 
> Since it apparently already happens in 2.6.19 (but it would be really good 
> to know exactly when it starts), and considering _where_ it happens, I'd 
> be inclined to blame commit d2e7b7d0: "fix potential stack overflow in 
> mm/slab.c" by Suresh. 
> 
> When do_tune_cpucache() is called at bootup, I'm not sure how safe it is 
> to do the kzalloc() thing.
> 
> I've added a number of hopefully appropriate people to the Cc. Guys? 
> Apparently it only happens with MEMORY_HOTPLUG (and possibly with just an 
> SMP kernel on UP), which probably explains why it's been around without 
> people really complaining very loudly. 
> 

I discussed this with Yasunori Goto <y-goto@jp.fujitsu.com> (memory
  hot-add developer):

 "But this config uses CONFIG_MEMORY_HOTPLUG_RESERVE which is made by
  Andi Kleen-san and I don't know very well around here.  And, I couldn't
  reproduce this trouble on my box."

I cannot reproduce it with Pawel's config either.

