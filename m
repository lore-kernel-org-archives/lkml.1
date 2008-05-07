Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYEGAzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYEGAzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYEGAzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:55:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:59451 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYEGAzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:55:21 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506.144301.233784820.davem@davemloft.net>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 07 May 2008 10:54:43 +1000
Message-Id: <1210121683.21644.194.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 14:43 -0700, David Miller wrote:
> > So I rewrote the title to "drivers/video/aty/radeon_base.c: notify
> user if
> > sysfs_create_bin_file() failed".
> > 
> > And your fix looks appropriate - if sysfs_create_bin_file() fails we
> will now get
> > reports of this and we can find out what kernel bug caused this to
> happen.
> 
> The last time someone "fixed" this warning in the radeon driver,
> people lost their consoles.
> 
> Just giving a heads up...

I asked Tony to only warn. I still don't like it tho. As I (and paulus)
have explained several times in the past, but I'm not going to veto the
patch because I'm tired of that argument.
 
We have something like 99% of users of sysfs_create_file not supposed to
fail right ?

So what we are effectively doing is adding -hundreds- of printk's all
over the place (bloat bloat bloat) while instead we could have warned
inside sysfs_create_file itself, and provided a __sysfs_create_file or
sysfs_create_file_nowarn, or whatever you want to call it for the
handful of users that actually want to explicitely deal with failures.

And it's the same for a whole bunch of those must check things. We are
just adding bloat often for nothing useful. In some case, even harmful
as we prevent entire modules from initializing due to what is often just
a minor failure.

Ben.


