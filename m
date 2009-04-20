Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZDTTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZDTTix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZDTTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:38:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbZDTTin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:38:43 -0400
Date: Mon, 20 Apr 2009 12:20:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-Id: <20090420122044.7ea6cc15.akpm@linux-foundation.org>
In-Reply-To: <20090407080632.GG1408@ucw.cz>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090417063007.GB4593@kernel.dk>
	<49E83DC4.8040207@tuffmail.co.uk>
	<20090417091321.GP4593@kernel.dk>
	<alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
	<20090407080632.GG1408@ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 10:06:32 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> > And the thing is, that "swsusp_shrink_memory()" is just full of 
> > heuristics. There's no hard numbers there. It doesn't seem to wait for 
> > writeout, it just does the equivalent of "shrink_list()" and 
> > "shrink_slab()", but it seems to have been basically cribbed half-way 
> > from the regular "try to free memory", without really doing it all.
> 
> akpm designed shrink_memory(). Long time ago it was just while (1)
> kmalloc() loop. It should be waiting. Andrew?

I always wanted the thing to just allocate all the memory which it
needed and then to either return it all to the caller or free it all
again for the caller to reallocate (preferably the former).

But for some reason which I don't recall (Pavel provided it, iirc) that
doesn't work.  So the current (and subsequently tweaked) scheme was put
in there instead.  It turned out to be surprisingly difficult and ugly
to graft it in top of the existing page reclaim code, and various
changes were subsequently made to make it sort-of-work.

Remind me: why can't we just allocate N pages at suspend-time?
