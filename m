Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbXK3SGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbXK3SGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXK3SGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:06:42 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1784 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXK3SGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:06:41 -0500
Subject: Re: RFC - organize include/linux/kernel.h, add
	include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071130092842.GA6221@localhost.sw.ru>
References: <20071130092842.GA6221@localhost.sw.ru>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 10:04:31 -0800
Message-Id: <1196445871.22120.178.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 12:28 +0300, Alexey Dobriyan wrote:
> > kernel.h has become a bit disorganized over a long time.
> > Here's an attempt to clean it up a bit.
> > Something for everyone to like or dislike...
> You duplicate ALIGN macros all over the place.
> > This one used the ALIGN macro, but I'm not inclined to
> > figure out what it actually does right now, so copy
> > the old macro to this file and renames it.
> Which is not acceptable. Ditto for DIV_ROUND_UP.

There were 3 instances where macros were
used to specify an array size.  It seems
cleaner to use SEs and direct use of calculations
for those 3 instances. (ymmv)

What would you expect this to do?

        struct {
        	unsigned char ha[ALIGN(32,sizeof(unsigned long))];
        } foo;
        
A casual reading might suggest 0.

> And you somehow decided that putting statements on one line is more
> readable than on multiple lines -- typecheck and friends.

That appears to be the generally accepted coding style
for macros and statement expressions.

Whatever is agreed to is fine by me.

> Overall impression -- moving code just because you can.

Yes. It's definitely a cleanup.

I think creating a separate include for the printk related
defines and functions will be useful for possible future
improvements to logging.

There are many private logging definitions that could be
consolidated in generic way.  Things like:

	#define MY_PRINTK(fmt, arg) print(PFX fmt, ##arg)

cheers, Joe

