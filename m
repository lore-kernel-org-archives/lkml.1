Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZC1KtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZC1KtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 06:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZC1KsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 06:48:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbZC1KsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 06:48:14 -0400
Subject: Re: DRM lock ordering fix series
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Eric Anholt <eric@anholt.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <49CDE401.2020502@inria.fr>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
	 <1238171805.8275.2434.camel@gaiman.anholt.net>
	 <20090327181018.GC11935@one.firstfloor.org>
	 <1238184629.625.44.camel@gaiman.anholt.net>
	 <1238201922.4039.403.camel@laptop>  <49CDE401.2020502@inria.fr>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 11:48:03 +0100
Message-Id: <1238237283.4039.605.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 09:46 +0100, Brice Goglin wrote:
> Peter Zijlstra wrote:
> > Also note that doing large gup() with gup_fast() will be undesirable due
> > to it disabling IRQs. So iterating say several MB worth of pages will
> > hurt like crazy. Currently all gup_fast() users do a single page lookup.
> >   
> 
> In 2.6.29, fs/bio.c:955, fs/direct-io.c:153 and fs/splice.c:1222 do
> multiple-pages lookup at once. The latter might be limited to 16 pages
> because of the pipe-depth, I don't know about the formers.
> 
> Is there some sort of reasonable limit? A couple dozens pages at once maybe?

Depends on your latency requirements, looking at the code I'd say we'd
have to add that batch limit the comment talks about. I'd see preempt-rt
wanting to lower that significantly.

Regular mainline could do with 32-64 I guess, max irq latency is well
over 10ms on mainline anyway.

