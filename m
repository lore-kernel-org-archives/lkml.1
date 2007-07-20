Return-Path: <linux-kernel-owner+w=401wt.eu-S936437AbXGTWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936437AbXGTWLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbXGTWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:11:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40142 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbXGTWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:11:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sat, 21 Jul 2007 00:19:39 +0200
User-Agent: KMail/1.9.5
Cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707202328.25126.rjw@sisk.pl> <87ejj2pxoc.fsf@jbms.ath.cx>
In-Reply-To: <87ejj2pxoc.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210019.40762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 23:33, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [snip]
> 
> >> Or add a small bit of infrastructure that errors writes at make_request 
> >> if you don't have a magic "i am a direct block device write from 
> >> userspace" flag on the bio.
> >> 
> >> The hibernate may fail, but you don't corrupt the media.
> >> 
> >> If you don't get the image out, resume back to the "this is resume" 
> >> instead of the power-down path.
> 
> > Well, I don't think that is much prettier than the freezer ...
> 
> It seems that a better solution to the "how do we write to a file on an
> in-use partition" has been suggested, which also handles swap partitions
> and swap files, and does not require mounting filesystems, so it seems
> that the filesystem issue need not be considered.
> 
> [snip]
> 
> > No.  I'm saying that when you go back from the image-saving kernel to the
> > hibernated kernel, you need to make sure that no task will cause any
> > filesystem's on-disk state to be actually updated.  If you can't make such
> > a guarantee, you just can't do that.
> 
> > With the current state of the drivers, it's not doable without the
> > freezer.
> 
> It seems that it should be feasible to fix the drivers so that
> 
> 1. they can be taken from normal state to quiesced state without
>    requiring the freezer;
> 
> 2. they can be taken from normal state to low power state without
>    requiring the freezer;

Yes, that's correct.

> 3. they can be taken from quiesced state to low power state without
>    requiring the freezer.
>
> In the particular, it seems that it should be possible to do (3) without
> needing to schedule tasks.

For that, you'd have to forbid the drivers to call schedule() from the relevant
callbacks, which means, eg. no timeouts in there.

> It seems likely that (2) may in fact be almost exactly the same as, or
> at least similar to, (1) followed by (3), at least for many drivers.
> (1) is required by the kexec hibernate approach even ignoring suspend to
> both or S4.  (2) is required for suspend to ram without the freezer,
> which seems to be desired anyway.

Yes, (2) is needed anyway.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
