Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbXHAP5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbXHAP5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXHAP5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:57:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27196 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbXHAP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:57:29 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1185981585.9513.119.camel@ghaskins-t60p.haskins.net>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185969554.9513.106.camel@ghaskins-t60p.haskins.net>
	 <1185981025.2636.102.camel@imap.mvista.com>
	 <1185981585.9513.119.camel@ghaskins-t60p.haskins.net>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 08:55:52 -0700
Message-Id: <1185983752.2636.116.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 11:19 -0400, Gregory Haskins wrote:
> On Wed, 2007-08-01 at 08:10 -0700, Daniel Walker wrote:
> 
> > 
> > rt_mutex_setprio() is just a function. It was also designed specifically
> > for PI , so it seems fairly sane to use it in other PI type
> > situations ..
> > 
> 
> Yes.  It is designed for PI and I wasn't suggesting you shouldn't use
> the logic itself.  What I was suggesting is that dealing with an API
> that has "rt_mutex" in it for something that has nothing to do with
> rt_mutexes is, well...

It's fine for now .. One step at a time..

> All I was suggesting is that we break out the PI subsystem from rt_mutex
> code so its an independent PI API and have the rt_mutex subsystem become
> a user.   That's a far cleaner way to do it, IMHO.

The workqueues don't really need full blown transitive PI. So without
that your back to the rt_mutex_setprio function .. Which could be
renamed ..

Here was my attempt years ago , 

http://lkml.org/lkml/2005/5/31/288

Looking back on it, I'm not sure what users I was planning to implement
along with it .. I'm sure I was thinking "There must be other blocking
primitives that could use this.." , but now I don't think there are ..
Everything pretty much runs through the rt mutex.. workqueues are just
"dancing" , or changing priorities up/down which is really only the
lowest level of what the rt-mutex does.

Daniel

