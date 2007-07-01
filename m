Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbXGAVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbXGAVan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXGAVaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 17:30:01 -0400
Received: from ns.suse.de ([195.135.220.2]:60491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXGAV37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 17:29:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: blink driver power saving
Date: Sun, 1 Jul 2007 23:29:52 +0200
User-Agent: KMail/1.9.6
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070701125035.3f54d8b0@oldman> <alpine.LFD.0.98.0707011106030.1172@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0707011106030.1172@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707012329.52918.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 July 2007 20:07:21 Linus Torvalds wrote:
> 
> On Sun, 1 Jul 2007, Stephen Hemminger wrote:
> >
> > The blink driver wakes up every jiffies which wastes power unnecessarily.
> > Using a notifier gives same effect. Also add ability to unload module.
> 
> I really get the feeling this thing should be removed entirely. Wasting 
> power is the _least_ of its problems.

What is so bad with it? Note it's a debugging facility and used 
for kcrash kernels where the video output doesn't work. But they
normally only run a few minutes to dump the previous state to disk
and then reboot. 

> I'll apply the patch, but I wonder if I should also just mark it BROKEN in 
> the config file to make sure nobody enables it without realizing how bad 
> it is to do so.

Well I suspect it will not work anymore after Stephen's patch
(or rather try to blink redundantly after panic which is quite dumb) 
If that is your aim then it might be cleaner to remove it.

But then I don't think it hurts anybody.  It's main problem
is that it won't blink for people with USB keyboard.

-Andi
