Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZANOjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZANOjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZANOjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:39:32 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:39278 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZANOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=taT+R1Y9GoGO/bE3ac2pTpTT/TRbU2Sjl+CB6YxgpQsh2ECdTgENpwZMQnCJkOnOfh
         FgNwdLg2AoXsmuyp838idbmnSNqRCTPDQ5XdMgSRDJ3Quv7Fo0ebW1eaS1/WMOQZH76B
         E2jpRGpBLvXrdpDx3YSqJ0lcwFIBWUfOCq4CY=
Date: Wed, 14 Jan 2009 14:39:22 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Denys Fedoryschenko <denys@visp.net.lb>, Chris Caputo <ccaputo@alt.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090114143922.GB6643@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop> <200901141505.46929.denys@visp.net.lb> <20090114131257.GC6117@ff.dom.local> <1231938929.14825.6.camel@laptop> <20090114132603.GD6117@ff.dom.local> <1231939946.14825.9.camel@laptop> <20090114141311.GA6643@ff.dom.local> <1231943283.14825.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231943283.14825.14.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:28:03PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-01-14 at 14:13 +0000, Jarek Poplawski wrote:
> > On Wed, Jan 14, 2009 at 02:32:26PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-01-14 at 13:26 +0000, Jarek Poplawski wrote:
> > > 
> > > > OK, I hope Denys can apply more, but what about others? Without any
> > > > patches the hole seems to be much bigger.
> > > 
> > > OK, I read most of this thread on netdev, but didn't find a clear clue
> > > on the specific hrtimer insertion race.
> > 
> > There is something at the beginning of this thread, plus earlier
> > threads mostly with Denys as sender, and "htb bug" in the subject.
> > 
> > > 
> > > Do you have any clear ideas or should I poke at the htb/hrtimer code a
> > > little?
> > > 
> > 
> > ....And htb code is htb_dequeue(): qdisc_watchdog_schedule().
> 
> Right, found all that...
> 
> Can't spot anything obviously wrong though.. hrtimer_start*() does
> remove_hrtimer() which checks STATE_ENQUEUED, STATE_PENDING and pulls it
> off the relevant list before it continues the enqueue.
> 
> However a loop in enqueue_hrtimer() would suggest a corrupted RB-tree,
> but I cannot find an RB-op that doesn't hold base-lock.
> 

Anyway I think some trace in rbtree seemed to show the parent is the
same with the node, if I didn't mess anything.

Jarek P.
