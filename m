Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbXFRHod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbXFRHod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXFRHo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:44:26 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39877 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXFRHo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:44:26 -0400
Date: Mon, 18 Jun 2007 09:45:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: More __meminit annotations.
Message-ID: <20070618074529.GA21222@uranus.ravnborg.org>
References: <20070618045229.GA31635@linux-sh.org> <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618143943.B108.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:49:24PM +0900, Yasunori Goto wrote:
> >  }
> >  
> > -static inline unsigned long zone_absent_pages_in_node(int nid,
> > +static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
> >  						unsigned long zone_type,
> >  						unsigned long *zholes_size)
> >  {
> 
> I thought __meminit is not effective for these static functions,
> because they are inlined function. So, it depends on caller's 
> defenition. Is it wrong? 

As we do not _know_ if a given function is inline or not it definitely
makes sense to mark them as __meminit.
If the compiler then decides to inline the function we are all clear and
no problems. If the compiler decides not to inline the function we will
properly discard the code after init has completed so again all clear.

And btw. some people (including myself) consider it a bug that gcc inline
a function that is forced to a specific section into a function that belongs
to another section. Now gcc people has another view but that may change.
So again defining a function as __meminit makes sense no matter the
section marker.

For the technical merit whay a function is marker inline in the first place.
It must be assumed this is a hot path where it is benificial to do so.

	Sam
