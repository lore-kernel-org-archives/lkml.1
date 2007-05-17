Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXEQV5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXEQV5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbXEQV45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:56:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:51734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbXEQV44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:56:56 -0400
Date: Thu, 17 May 2007 23:56:54 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Morton Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070517215654.GA31149@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	Morton Andrew Morton <akpm@linux-foundation.org>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de> <20070508171841.GA29733@in.ibm.com> <20070514140513.GD29616@suse.de> <20070517130527.GF28280@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517130527.GF28280@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-05-17 15:05]:
> On Mon, May 14, 2007 at 04:05:15PM +0200, Bernhard Walle wrote:
> > * Vivek Goyal <vgoyal@in.ibm.com> [2007-05-08 19:18]:
> > > On Thu, May 03, 2007 at 12:19:32AM +0200, Bernhard Walle wrote:
> > > > * Vivek Goyal <vgoyal@in.ibm.com> [2007-04-30 10:48]:
> > > > > 
> > > > > handle_edge_irq() already makes sure that desc->action is not null, still
> > > > > note_interrupt() is receiving desc->action as null, that's strange. On my 
> > > > > system this is happening for irq 4 and /proc/interrupt shows that it is
> > > > > coming from "serial".
> > > > 
> > > > Unfortunately, I couldn't reproduce this here. Vivek, do you have time
> > > > to take a look at this at your site? For the meanwhile, should I
> > > > create a patch that checks for desc->action in note_interrupt(), too?
> > > 
> > > I can reproduce this problem only on one machine. I think there is some
> > > race condition and your code somehow just exposes it.
> > 
> > thanks for finding that out. Could you try/review out the patch below?
> > As the lock is only aquired when irqfixup == 2 it shouldn't impact
> > performance of a 'normal' system.
> 
> It does fix up my problem. I have modified your patch a bit. I think
> new version is little more clear. What do you think?

Aggreed. Thanks for spotting that problem out!


Bernhard
