Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXEZACf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXEZACf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 20:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXEZAC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 20:02:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbXEZAC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 20:02:27 -0400
Date: Fri, 25 May 2007 17:02:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Matt Mackall <mpm@selenic.com>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-Id: <20070525170209.40ad51d5.akpm@linux-foundation.org>
In-Reply-To: <20070525231257.GA9616@suse.de>
References: <20070525163621.GE11166@waste.org>
	<20070525164842.GA6220@suse.de>
	<3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com>
	<20070525175319.GK11115@waste.org>
	<20070525210152.GL11115@waste.org>
	<20070525230109.GN11115@waste.org>
	<20070525231257.GA9616@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 16:12:57 -0700 Greg KH <gregkh@suse.de> wrote:

> On Fri, May 25, 2007 at 06:01:09PM -0500, Matt Mackall wrote:
> > Bisect sequence went 56+ 84+ 98+ 105- 102- 100+ 101+. Looks like 102's
> > to blame:
> > 
> > driver-core-check-return-code-of-sysfs_create_link.patch 
> > 
> > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > 
> > Check for return value of sysfs_create_link() in device_add() and
> > device_rename().  Add helper functions device_add_class_symlinks() and
> > device_remove_class_symlinks() to make the code easier to read.
> 
> {sigh}
> 
> This wouldn't be the first time this patch has broken things :(

Why does checking these errors cause ipw2200 to fail?

> Andrew, can you drop this from your tree?

Would prefer that we debug things first.  It could be that ipw2200 is
trying to create symlinks which already exist.  This might indicate a
programming error in ipw2200, which is what the patch is *for*.  If it
is indeed an ipw2200 bug then the lesson is that we should have been checking
for errors on day one - that way, we'd never have shipped a buggy ipw2200 driver.

I have an ipw2200 - I'll see if I can reproduce this and I'll add some
debugging code in there.  Probably that debugging code should become
permanent.

> Cornelia, can you rework this to not break things?

Things might be already broken?
