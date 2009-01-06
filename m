Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZAFXT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZAFXT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZAFXTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:19:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZAFXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:19:48 -0500
Date: Tue, 6 Jan 2009 15:19:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106151915.df138883.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> 
> > linuxpps-core-support.patch
> 
> looks generally good, but the comments should get a little loving.
> Please remove the stupid filenames that always get out of sync in
> the top of file comments, and make the documentation of exported
> symbols kernel-doc instead of it's weird own format.
> 
> Does checkpatch.pl still not catch these things?
> 
> Also the ioctl certainly should be an unlocked_ioctl and not the
> old BKL-locked variant. The !uarg checks in the ioctls can go,
> copy_to/from_users does this automatically.
> 
> pps.h shoulkd be split into one header only defining the
> kernel<->userspace ABI, and a kernel-internal one.  That way
> also the conditional includes can go away.
> 
> > pps-documentation-programs-and-examples.patch
> 
> Once again this stuff is in and utterly wrong place where it can't
> easily be package for distros.  ppsfind belongs into util-linux and
> needs a proper mangage, ppsldisc is not nessecary but ldattach in
> util-linux needs to grow support for N_PPS instead, and ppstest
> should probably go into util-linux in a more polished version, too.
> 
> > pps-userland-header-file-for-pps-api.patch
> 
> This one is utterly wrong.  It provides what should be a userspace
> library as inlines in a kernel header. 
> 
> Please do a proper libpps library package.

Well that's a drop-it-all-and-start again scale of thing.

Rodolfo, do you have sufficient information here?
