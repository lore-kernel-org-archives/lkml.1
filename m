Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXAaQJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXAaQJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030221AbXAaQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:09:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36084 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030219AbXAaQJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:09:14 -0500
Date: Wed, 31 Jan 2007 08:04:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?Pawe=C5_Sikora?= <pluto@agmk.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <45C05150.6000802@agmk.net>
Message-ID: <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <45C05150.6000802@agmk.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1580412864-1170259469=:3632"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1580412864-1170259469=:3632
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 31 Jan 2007, PaweÅ Sikora wrote:
> 
> The 2.6.20-rcX have the same nasty bug as 2.6.19.x.
> 
> [ an oops inside kmem_get_pages ]
> http://bugzilla.kernel.org/show_bug.cgi?id=7889

Pabel, can you detail more exactly which kernels don't work, and which do?

>From bugzilla:

 - 2.6.18.x does work
 - 2.6.19.2 doesn't work.
 - what about plain 2.6.19?
 - can you please test some of the 2.6.19-rcX kernels? Especially 
   2.6.19-rc1 would be good to test.

Since it apparently already happens in 2.6.19 (but it would be really good 
to know exactly when it starts), and considering _where_ it happens, I'd 
be inclined to blame commit d2e7b7d0: "fix potential stack overflow in 
mm/slab.c" by Suresh. 

When do_tune_cpucache() is called at bootup, I'm not sure how safe it is 
to do the kzalloc() thing.

I've added a number of hopefully appropriate people to the Cc. Guys? 
Apparently it only happens with MEMORY_HOTPLUG (and possibly with just an 
SMP kernel on UP), which probably explains why it's been around without 
people really complaining very loudly. 

		Linus
---1463790079-1580412864-1170259469=:3632--
