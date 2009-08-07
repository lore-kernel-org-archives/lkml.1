Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZHHPZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZHHPZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZHHPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:25:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZHHPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:25:11 -0400
Date: Fri, 7 Aug 2009 20:08:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090807180841.GC1728@ucw.cz>
References: <4A6D79F6.3050509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6D79F6.3050509@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Well, it may be a good, bad, idiotic or brilliant idea depending on your
> personal philosophy.  I went down this route out of pragmatism.
> Hopefully I have not fully re-invented the wheel.

I did, long ago. I called it nbd... aha and you know about it (from
following mails in thread).

> accidental deadlock.  There may of course be some hidden deep deadlock
> potential in such a device, especially if one decided to use it as a
> swap device, but again, this is a philosophical issue.

What's philosophical about 'it does not work for swap or dirty mmap'?

(last time I checked, dirty mmap data behaved very much like swap).

(And yes, nbd has same problem. It should be safe for r/o access to
localhost, but may deadlock when it is mounted locally...)

And yes, I believe that's show stopper. OTOH if you _can_ solve
that... then you have some rather significant advantage over nbd.

(But guaranteeing progress for dirty writeout will be tricky even with
mlocked userland, AFAICT...)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
