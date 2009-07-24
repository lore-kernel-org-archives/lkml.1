Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZGXVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZGXVCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZGXVCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:02:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZGXVCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:02:31 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, jengelh@medozas.de, aviro@redhat.com,
       mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
In-Reply-To: <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm>
References: <1248466429.3567.82.camel@localhost>
	 <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 17:01:18 -0400
Message-Id: <1248469278.3567.88.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 13:48 -0700, david@lang.hm wrote:
> getting an open fd to the file is good for things like content scanning, 
> but for other things like a HSM re-populating the file, you would need to 
> pass the path used to open the file at open time. is this in the metadata 
> you are passing?

No, I will NOT EVER pass a pathname.  Period.  End of story.  I stated
the if userspace wants to deal with pathnames (and they understand the
system setup well enough to know if pathnames even make sense to them)
they can use readlink(2) on /proc/self/fd

> to avoid race conditions, you may want some way that a listener on a 
> directory can flag that it wants to also be a listener for all new 
> directories created under the one it is listening on.

Interesting way to get the subtree checking people want, you do the
registration yourself the first time on the entire hierarchy and new
directories will be automagically added.  I could probably do that, I'll
have to look.

> with the PERM checks, can a checker respond within the 5 second window 
> with 'I need more time'? or does it need to complete all it's work in <5 
> seconds?

FAN_RESET_TIMEOUT

