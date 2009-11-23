Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZKWTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZKWTt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZKWTt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:49:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49910 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbZKWTtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:49:55 -0500
Date: Mon, 23 Nov 2009 20:50:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kay Sievers <kay.sievers@vrfy.org>,
       David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091123195000.GK8742@kernel.dk>
References: <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <20091122233749.GA9699@ucw.cz> <20091123141754.GE8742@kernel.dk> <20091123142557.GA10084@srcf.ucam.org> <20091123143140.GG8742@kernel.dk> <20091123144238.GA10275@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123144238.GA10275@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23 2009, Matthew Garrett wrote:
> On Mon, Nov 23, 2009 at 03:31:40PM +0100, Jens Axboe wrote:
> 
> > Well, take a look at laptop mode. A timer per-io is probably
> > unavoidable, but doing it at IO completion could mean a big decrease in
> > timer activity as opposed to doing it for each incoming IO. And since
> > you are looking at when the disk is idle, it makes a lot more sense to
> > me to do that when the we complete a request (and have no further
> > pending IO) rather than on incoming IO.
> 
> Right. The current implementation I have does a del_timer() at 
> submission (which should be moved to post-merge) - that should be cheap 
> in the common case of a new command being submitted when there's already 
> commands outstanding. There's then a mod_timer() at completion time. 
> That's still a certain amount of expense, but it should be less.
> 
> > Your biggest performance issue here is going to be sync IO, since the
> > disk will go idle very briefly before being kicked into action again.
> 
> Ok, I'll try to benchmark that.
> 
> The alternative (polling) method would be something much like Kay 
> suggested - either add an extra field to stat or an extra sysfs file, 
> then invalidate that on submission and set to jiffies on completion. 
> It's not ideal from a wakeups perspective, but it's pretty low impact on 
> the kernel side.

If the polling works out, then yes that approach is certainly a lot
better from a performance impact pov.

What kind of time intervals are you targetting?

-- 
Jens Axboe

