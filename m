Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXKRVcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXKRVcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbXKRVcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:32:46 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44045 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXKRVcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:32:46 -0500
Date: Sun, 18 Nov 2007 22:34:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071118213427.GB5696@uranus.ravnborg.org>
References: <200711182038.22055.deller@gmx.de> <20071118130503.7d5ec842.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071118130503.7d5ec842.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 01:05:03PM -0800, Andrew Morton wrote:
> On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:
> 
> > Title: Add time-based RFC 4122 UUID generator
> > 
> > The current Linux kernel currently contains the generate_random_uuid() 
> > function, which creates - based on RFC 4122 - truly random UUIDs and 
> > provides them to userspace through /proc/sys/kernel/random/boot_id and 
> > /proc/sys/kernel/random/uuid.
> > 
> > This patch additionally adds the "Time-based UUID" variant of RFC 4122, 
> > with which userspace applications can easily get real unique time-based 
> > UUIDs through /proc/sys/kernel/random/uuid_time.
> > A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is available,
> > so that the clock_seq value can be retained across system bootups (which
> > is required by RFC 4122).
> > 
> > The attached implementation uses getnstimeofday() to get very fine-grained
> > granularity. This helps, so that userspace tools can get a lot more UUIDs 
> > (if needed) per time than before.
> > A mutex takes care of the proper locking against a mistaken double creation 
> > of UUIDs for simultanious running processes.
> 
> Who will use this feature, and for what?
> 
> (In fact, who uses the existing UUID generators, and for what?)

I use libuuid and I assume libuuid uses some uuid generator support
from the kernel. libuuid comes from a package that Ted's maintain IIRC.

I (my company) use uuid to uniquely identify objects in a distributed
database.
[Proprietary closed source stuff].

	Sam
