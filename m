Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXJ0BTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXJ0BTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXJ0BTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:19:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXJ0BTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:19:38 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193429066.5648.35.camel@lappy>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site>  <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site>  <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site>  <1193429066.5648.35.camel@lappy>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 03:18:08 +0200
Message-Id: <1193447889.5648.44.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 22:04 +0200, Peter Zijlstra wrote:
> This crashes and burns on bootup, but I'm too tired to figure out what I
> did wrong... will give it another try tomorrow..

Ok, can't sleep.. took a look. I have several problems here.

The thing that makes it go *boom* is the __ATTR_NULL. Removing that
makes it boot. Albeit it then warns me of multiple duplicate sysfs
objects, all named "bdi".

For some obscure reason this device interface insists on using the
bus_id as name (?!), and further reduces usability by limiting that to
20 odd characters.

This makes it quite useless. I tried fudging around that limit by using
device_rename and kobject_rename, but to no avail.

Really, it should not be this hard to use, trying to expose a handfull
of simple integers to userspace should not take 8h+ and still not work.

Peter, who thinks sysfs is contorted mess beyond his skill. I'll stick
to VM and scheduler code, that actually makes sense.

