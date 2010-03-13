Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935278Ab0CMRo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 12:44:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1681 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934366Ab0CMRo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 12:44:56 -0500
Subject: Re: [PATCH] vsprintf.c: Use noinline_for_stack
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
In-Reply-To: <alpine.LFD.2.00.1003130734420.3719@i5.linux-foundation.org>
References: <cover.1267682641.git.joe@perches.com>
	 <20100304143837.af39845d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>
	 <1267911399.849.39.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
	 <1267914654.849.81.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>
	 <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain>
	 <1267918554.849.89.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>
	 <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>
	 <alpine.LFD.2.00.1003061556420.23804@localhost.localdomain>
	 <1267924214.1937.12.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061755400.23804@localhost.localdomain>
	 <1267929215.1937.18.camel@Joe-Laptop.home>
	 <20100312162559.a8e51777.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1003130734420.3719@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Mar 2010 09:44:55 -0800
Message-ID: <1268502295.30289.44.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 07:35 -0800, Linus Torvalds wrote:
> On Fri, 12 Mar 2010, Andrew Morton wrote:
> > nice.
> But the kallsyms_lookup()/sprint_symbol() functions don't take a 
> length parameter, so we have to do the worst-case thing (which itself has 
> tons of unnecessary padding).

I sent a patch once about that using a struct
because I didn't like the unbounded sprint
http://lkml.org/lkml/2009/4/15/16

> Gaah. We do _not_ want a kmalloc() or something like that in this path, 
> since its' very much used for oopses (which in turn may be due to various 
> slab bugs etc).

Perhaps a new snprint_symbol function with the
other kallsyms... functions changed as necessary.

thoughts?

