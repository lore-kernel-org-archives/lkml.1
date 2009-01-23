Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZAWGAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZAWGAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZAWGAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:00:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZAWGAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:00:36 -0500
Date: Fri, 23 Jan 2009 07:15:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090123061557.GM15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122221500.4c62aa54@tpl> <20090122213105.74142908.akpm@linux-foundation.org> <1232689549.5202.385.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232689549.5202.385.camel@calx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have to agree with Christoph. The priority here is breaking down the
> BKL and document all the things being protected by it and we've got a
> reasonably obvious patch in that direction. Meanwhile, there's not
> currently a pressing demand to make fasync in particular scale that I'm
> aware of.

The classic case is a high throughput network server that uses async
sockets. It has to call F_SETFL on each new socket it opens.

> Having a single big lock here is quite possibly something we'll want to
> fix down the road, agreed, but until we can actually measure it hurting
> us, debating about whether to use a bit lock or reuse an existing lock
> or add a new lock to all struct files is a bit premature.

I think i would agree with you if we didn't have a better patch
already, but if there's one it doesn't make sense not to use it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
