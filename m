Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXCUSAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXCUSAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCUSAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:00:02 -0400
Received: from lazybastard.de ([212.112.238.170]:41764 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbXCUSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:00:01 -0400
Date: Wed, 21 Mar 2007 18:54:13 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jarek Poplawski <jarkao2@o2.pl>, Eric Dumazet <dada1@cosmosbay.com>,
       mpm@selenic.com, Christoph Lameter <clameter@sgi.com>,
       "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070321175413.GC455@lazybastard.org>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI> <20070321133151.GC1939@ff.dom.local> <Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI> <200703211511.10342.rjw@sisk.pl> <84144f020703210741g4b6b2000kf19b439a4c42f445@mail.gmail.com> <20070321083027.437361f1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070321083027.437361f1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 March 2007 08:30:27 -0800, Andrew Morton wrote:
> On Wed, 21 Mar 2007 16:41:19 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> 
> > Yeah, I'll try to sneak a patch past Andrew.
> 
> That would be sneaky.
> 
> Thing is, such a patch would amount to adding a test-for-NULL to codepaths
> which we *know* do not need it.  There is no point in doing that.

How about two patches, one renaming kmem_cache_free to
kmem_cache_free_fast or __kmem_cache_free or whatever pleases you most,
the second adding kmem_cache_free with a NULL check.

The point is that the easiest way to use kmem_cache_free should be the
safest, but not necessarily the fastest.  Existing well-tuned and
NULL-aware code paths can remain fast, random new code will be safe.

Jörn

-- 
Joern's library part 14:
http://www.sandpile.org/
