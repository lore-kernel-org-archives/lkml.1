Return-Path: <linux-kernel-owner+w=401wt.eu-S1765443AbZFQJoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765443AbZFQJoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZFQJoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:44:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58214 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZFQJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:44:15 -0400
Date: Wed, 17 Jun 2009 11:38:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: J Louis <handstogether8@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux scheduler capabilities for batch jobs.
Message-ID: <20090617093851.GA1403@ucw.cz>
References: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f41bd4b0906010641n1b360dffs6eaed72eb24f60f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-01 09:41:07, J Louis wrote:
> Hello All,
> 
> I have been writing user land server code and increasingly I find
> myself writing resource management code which I think would be better
> handled by the scheduler.  The problem can be described as "don't run
> this process if the machine is swapping."  I would think that this
> would be a common enough need that it was already in the kernel.  I'm
> hoping it is and I have simply overlooked it (part of the reason for
> this post,) but I've looked around a good bit and most of the
> scheduler enhancements have to do with real time and latency, not
> batch jobs.
> 
> My problem is analogous to a parallel make.  Say I have an 8 CPU
> machine, and I run "make -j8".  If the total memory of the 8 jobs
> throws the machine into swap, it begins to thrash and runtime is
> awful.  I believe this is aggravated by the scheduler trying to be

This seems to be racy by design.

make -j:
     launch gcc1
     gcc1 does preprocessing (10mb)  
     ok, still not swapping
     launch gcc2
     gcc2 does preprocessing (10mb)  
     ...
     gcc100 does preprocessing (10mb, 1GB total)
now gcc1..gcc100 start optimizing (100mb needed) and boom.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
