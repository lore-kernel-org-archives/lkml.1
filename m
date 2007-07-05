Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbXGEJLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbXGEJLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbXGEJKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:10:53 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:16240 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757952AbXGEJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:10:52 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183626507.3818.19.camel@johannes.berg>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705085304.GC3476@elte.hu>  <1183625889.3818.14.camel@johannes.berg>
	 <1183626070.7054.54.camel@twins>  <1183626507.3818.19.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:10:47 +0200
Message-Id: <1183626647.7054.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 11:08 +0200, Johannes Berg wrote:
> On Thu, 2007-07-05 at 11:01 +0200, Peter Zijlstra wrote:
> 
> > You could of course make this STATIC_LOCKDEP_MAP_INIT() and place it
> > near lockdep_init_map() :-)
> > 
> > That way it would be clear that changes to either ought to be reflected
> > in the other.
> 
> Sure. I have to repost anyway :)
> 
> How about
> 
> +/* both _name and _key must not be NULL */
> +#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
> +	{ .name = (_name), .key = (_key), }

looks sane enough :-)

> That'll still require some #ifdef foo inside workqueue.h but I think
> it's cleaner to put just this into lockdep.h

It is.

