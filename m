Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZACBJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZACBJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbZACBJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:09:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbZACBJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:09:01 -0500
Date: Fri, 2 Jan 2009 20:08:58 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@infradead.org>
Subject: Re: 2.6.27/2.6.28: irqbalance dies shortly after starting the
	daemon on x86 but not x86_64, why?
Message-ID: <20090103010858.GD5181@bombadil.infradead.org>
References: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan> <495E93D4.3060401@linux.intel.com> <alpine.DEB.1.10.0901021931140.19502@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901021931140.19502@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 07:32:21PM -0500, Justin Piszcz wrote:
> The CPU = E6700 so yep, so if there is one physical socket with 4 cores it
> keeps?  For it to keep and not oneshot you need > 2 cores?
>

It depends... if your 4-core is laid out with four cores sharing one
external cache, then it will terminate, if, say you had 4 cores with
each pair sharing a cache (so two external caches) then it would
continue as a daemon. (If you had 2 sockets with a processor in each
one, it would continue running as well no matter how many cores on
each.)

If you run irqbalance --debug, it will show you the topology it detects.
If you have multiple cache domains, and it is still exiting, then we
have a bug. :)

cheers, Kyle
