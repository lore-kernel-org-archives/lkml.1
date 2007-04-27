Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXD0Q63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXD0Q63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXD0Q63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:58:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32898 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756082AbXD0Q62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:58:28 -0400
Date: Fri, 27 Apr 2007 09:58:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 -- PPC link failure
In-Reply-To: <46322AFD.5000706@shadowen.org>
Message-ID: <Pine.LNX.4.64.0704270956480.1762@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4630A662.8090502@shadowen.org> <4630ABF2.1040305@shadowen.org>
 <4630EBFA.9000207@shadowen.org> <Pine.LNX.4.64.0704261123080.3560@schroedinger.engr.sgi.com>
 <4630F203.7020005@shadowen.org> <Pine.LNX.4.64.0704261210430.7441@schroedinger.engr.sgi.com>
 <46310216.2070608@shadowen.org> <Pine.LNX.4.64.0704261320090.5678@schroedinger.engr.sgi.com>
 <46322AFD.5000706@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andy Whitcroft wrote:

> > See my patch @ http://marc.info/?l=linux-kernel&m=117752927203466&w=2
> 
> Yeah I played with that for a bit last night to no good effect.
> BUILD_BUG_ON simply becomes a noop if the optimiser doesn't really
> really know that the thing its talking about is a real constant.

Too bad. Sigh.

> I assume that if it cannot be sure that it should constant fold the
> number, it leaves it for runtime.  Then the optimiser sees that the
> thing is void and therefore removable and removes it.  So no error.
> 
> Perhaps we need to enlist someone from gcc-land to tell us how to figure
> out what its doing and massage it into working.

In the meantime how about moving that generation of the link err out of 
SLUB and SLAB into kernel.h and make some BUILD_BUG() or so out of it? We 
are talking about some generically useful functionality I guess.

