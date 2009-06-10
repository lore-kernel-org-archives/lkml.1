Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbZFJQHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbZFJQHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbZFJQG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:06:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51871 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbZFJQGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:06:55 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com
In-Reply-To: <1244649174.6165.0.camel@johannes.local>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
	 <1244648659.23799.26.camel@penberg-laptop>
	 <1244648968.23799.27.camel@penberg-laptop>
	 <1244649174.6165.0.camel@johannes.local>
Date: Wed, 10 Jun 2009 19:06:55 +0300
Message-Id: <1244650015.23799.29.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 17:52 +0200, Johannes Berg wrote:
> On Wed, 2009-06-10 at 18:49 +0300, Pekka Enberg wrote:
> > On Wed, 2009-06-10 at 18:44 +0300, Pekka Enberg wrote:
> > 
> > > Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
> > > CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
> > > help. Christoph, are you okay with this patch?
> 
> 
> > +	if ((size + MAX_DEBUG_SIZE) >= PAGE_SIZE)
> 
> && size <= PAGE_SIZE
> 
> ? Or is this a path that only happens for small allocations?

Anything that's beyond PAGE_SIZE * 2 is passed straight to the page
allocator and the intent of this patch is to disable debugging for all
big caches like SLAB does.

			Pekka

