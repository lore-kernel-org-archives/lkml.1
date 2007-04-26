Return-Path: <linux-kernel-owner+w=401wt.eu-S1031495AbXDZWHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031495AbXDZWHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031498AbXDZWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:07:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39744 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031495AbXDZWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:07:12 -0400
Date: Thu, 26 Apr 2007 15:07:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       AKPM <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] change global zonelist order on NUMA v2
In-Reply-To: <1177624660.5705.72.camel@localhost>
Message-ID: <Pine.LNX.4.64.0704261504090.19704@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
 <1177624660.5705.72.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Lee Schermerhorn wrote:

> Against 2.6.21-rc7 atop KAMEZAWA Hiroyuki's "change global zonelist
> order on NUMA v2" patch.

Hmmm.. hmmm... serious hackery here. Isnt there some way to simplify the 
core impact and make the arch select a strategy? A boot option would be
less impact (I am a bit concerned about switching zonelist mid stream).

The arch should be able to specify a default zone order. So the best thing 
would be to make the zone orders configurable in the page allocator and 
then have the arch code determine a default order depending on the 
hardware that we are running on.

Make sure that the !CONFIG_ZONE_DMA case works.

What about ZONE_DMA32 support?
