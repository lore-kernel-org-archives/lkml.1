Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbXLJVcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbXLJVcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXLJVbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:31:53 -0500
Received: from vena.lwn.net ([206.168.112.25]:32841 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757954AbXLJVbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:31:52 -0500
To: Daniel Phillips <phillips@phunq.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 05 Dec 2007 16:03:01 PST."
             <200712051603.02183.phillips@phunq.net> 
Date: Mon, 10 Dec 2007 14:31:52 -0700
Message-ID: <25797.1197322312@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Daniel,

I'm just getting around to looking at this.  One thing jumped out at me:

> +	if (bio->bi_throttle) {
> +		struct request_queue *q = bio->bi_queue;
> +		bio->bi_throttle = 0; /* or detect multiple endio and err? */
> +		atomic_add(bio->bi_throttle, &q->available);
> +		wake_up(&q->throttle_wait);
> +	}

I'm feeling like I must be really dumb, but...how can that possibly
work?  You're zeroing >bi_throttle before adding it back into
q->available, so the latter will never increase...

jon
