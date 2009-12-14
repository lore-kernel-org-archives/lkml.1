Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbZLNTIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbZLNTIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbZLNTI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:08:29 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbZLNTI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:08:28 -0500
Date: Mon, 14 Dec 2009 20:08:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] laptop-mode: Make flushes per-device
Message-ID: <20091214190827.GS8742@kernel.dk>
References: <20091211164433.GA1980@srcf.ucam.org> <1260554071-2190-1-git-send-email-mjg@redhat.com> <20091212122443.GA8742@kernel.dk> <20091214190544.GA6589@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214190544.GA6589@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14 2009, Matthew Garrett wrote:
> On Sat, Dec 12, 2009 at 01:24:43PM +0100, Jens Axboe wrote:
> 
> > That's because it is messy, why are you passing the request in? It
> > would be a lot more sane to pass in the queue, better still the backing
> > device.
> 
> It seemed conceptually cleaner for the completion to refer to the 
> request rather than anything else, but that's easily fixed.

It's rather a major layering violation, I would claim... Passing in the
bdi is design wise the cleanest.

> > What guarentees that the timer isn't running when the bdi goes away?
> 
> Good point. I'll fix these and resend.

Thanks! As you can tell, laptop mode was pretty much for a laptop with a
single drive back when it was created. It definitely seems like a good
idea to make it per-drive granular now.

-- 
Jens Axboe

