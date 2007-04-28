Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbXD1ATb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbXD1ATb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbXD1ATb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:19:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757937AbXD1ATa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:19:30 -0400
Date: Fri, 27 Apr 2007 17:18:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0704271706100.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280041.17617.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
 <200704280145.26253.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Linus Torvalds wrote:
> 
> The "let's stop all kernel threads" is superstition. It's the same kind of 
> superstition that made people write "sync" three times before turning off 
> the power in the olden times. It's the kind of superstition that comes 
> from "we don't do things right, so let's be vewy vewy quiet and _pray_ 
> that it works when we are beign quiet".

Side note: while I think things should probably *work* even with user 
processes going full bore while a snapshot it taken, I'll freely admit 
that I'll follow that superstition far enough that I think it's probably a 
good idea to try to quiesce the system to _some_ degree, and that stopping 
user programs is a good idea. Partly because the whole memory shrinking 
thing, and partly just because we should do the snapshot with hw IO queues 
empty.

But I don't think it would necessarily be wrong (and in many ways it would 
probably be *right*) to do that IO queue stopping at the queue level 
rather than at a process level. Why stop processes just becasue you want 
to clean out IO queues? They are two totally different things!

		Linus
