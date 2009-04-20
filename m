Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZDTTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZDTTvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZDTTu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:50:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37583 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbZDTTuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:50:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
Date: Mon, 20 Apr 2009 21:49:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <20090407080632.GG1408@ucw.cz> <20090420122044.7ea6cc15.akpm@linux-foundation.org>
In-Reply-To: <20090420122044.7ea6cc15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202149.33430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009, Andrew Morton wrote:
> On Tue, 7 Apr 2009 10:06:32 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > And the thing is, that "swsusp_shrink_memory()" is just full of 
> > > heuristics. There's no hard numbers there. It doesn't seem to wait for 
> > > writeout, it just does the equivalent of "shrink_list()" and 
> > > "shrink_slab()", but it seems to have been basically cribbed half-way 
> > > from the regular "try to free memory", without really doing it all.
> > 
> > akpm designed shrink_memory(). Long time ago it was just while (1)
> > kmalloc() loop. It should be waiting. Andrew?
> 
> I always wanted the thing to just allocate all the memory which it
> needed and then to either return it all to the caller or free it all
> again for the caller to reallocate (preferably the former).
> 
> But for some reason which I don't recall (Pavel provided it, iirc) that
> doesn't work.  So the current (and subsequently tweaked) scheme was put
> in there instead.  It turned out to be surprisingly difficult and ugly
> to graft it in top of the existing page reclaim code, and various
> changes were subsequently made to make it sort-of-work.
> 
> Remind me: why can't we just allocate N pages at suspend-time?

Well, IMO it may be worth trying anyway.

Thanks,
Rafael
