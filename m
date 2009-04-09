Return-Path: <linux-kernel-owner+w=401wt.eu-S936601AbZDIURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936601AbZDIURv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935433AbZDIURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:17:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762256AbZDIURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:17:41 -0400
Date: Thu, 9 Apr 2009 22:17:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-ish "fixes" in UBIFS
Message-ID: <20090409201722.GA1450@ucw.cz>
References: <49CCCB0A.6070701@nokia.com> <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de> <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com> <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com> <72dbd3150904021855v440f46a7oc21a7ed28fbfcb13@mail.gmail.com> <9b1675090904021905o7e0cec64lfe4a5372777908b6@mail.gmail.com> <72dbd3150904021919g5405ee40p100eacb085024941@mail.gmail.com> <9b1675090904021928k5a9948f9l8d93b6cbd5531720@mail.gmail.com> <72dbd3150904021958q7795dc62keb54d1fbfaa6abc7@mail.gmail.com> <20090403050246.GM9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403050246.GM9870@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I've got a problematic server with 8GB RAM.  Even if set both to 1,
> > that's 80MB and the crappy disks I have in it will often only write
> > 10-20MB/s or less due to the seekiness of the workload.  That means
> > delays of 5-10 seconds worst case which isn't fun.
> > 
> 
> Well, one solution is data=writeback.  If you're confident your server
> isn't going to randomly crash (i.e., it's on a UPS, and you're not
> running unstable video drivers), that might be a solution.  It has
> tradeoffs, though.
> 
> One thing which I'll probably implement is some patches to ext3 so
> that when it's in data=writeback mode, it will use the same
> replace-via-rename and replace-via-truncate hueristics that I added in
> ext4 so that it will start an aysnchronous writeout on the rename() or
> close() w/ truncate().  That should avoid existing files getting
> corrupted when they are replaced right before the system crashes.  

Truncate case is unfixable, but would it be possible to only do rename
after data are on disk? Because async writeout only makes catastrophic
data loss 'less probable'...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
