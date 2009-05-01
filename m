Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZEAWYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZEAWYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZEAWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:24:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbZEAWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:23:59 -0400
Date: Fri, 1 May 2009 15:21:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, jblunck@suse.de
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-Id: <20090501152133.e3f5038c.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510905011459i6cbf1199ua0670b82097a0309@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	<20090430222900.c13b63d5.akpm@linux-foundation.org>
	<ac3eb2510905010416q36c9e155ya4131cf82dfd13bc@mail.gmail.com>
	<20090501122625.a60ccbbe.akpm@linux-foundation.org>
	<ac3eb2510905011459i6cbf1199ua0670b82097a0309@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 23:59:32 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, May 1, 2009 at 21:26, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 1 May 2009 13:16:22 +0200
> > Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> >> On Fri, May 1, 2009 at 07:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> > dev->type->nodename() might have failed due to -ENOMEM, in which case
> >> > it seems wrong to assume that it returned NULL for <whatever reason you
> >> > thought it might want to return NULL>.
> >> >
> >> > It's all a bit confused.
> >>
> >> This logic is only for providing a custom name hint. Only a few
> >> devices need that at all. If the allocation fails, the default name
> >> will be used, not the custom name.
> >
> > But that's bad, isn't it? __It means that the kernel will come up with
> > one name if the memory allocation succeeded, and a different name if
> > the allocation failed.
> 
> Yeah, sure, it's bad. But I think we have pretty much lost anyway, if
> we run into oom at this stage.
> 
> What should we do instead? If we, for some reason, can not get a
> possible custom name?

Not much - just sayin'.

Presumably the page allocator will have given a big spew, so the
operator knows what went wrong.

