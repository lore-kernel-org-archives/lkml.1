Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXJZP4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXJZP4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXJZP4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:56:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbXJZP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:56:44 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193412836.27652.11.camel@twins>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <3ae72650710020421t711caaa8o13d2e685a98e5fe8@mail.gmail.com>
	 <1191325226.13204.63.camel@twins>
	 <200710022205.05295.nickpiggin@yahoo.com.au>
	 <1191406506.4093.35.camel@lov.localdomain>  <1191407872.5572.7.camel@lappy>
	 <1191418525.4093.87.camel@lov.localdomain> <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site>  <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site>  <1193412836.27652.11.camel@twins>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 17:55:47 +0200
Message-Id: <1193414147.2431.35.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19EvNFLMytMnE6wccjTfE91cfwzbn0vlLTRJGF
 vwEoTbyB7L5vb8Ryukul7rVMiiEW1BZP4Ixh+Mu9vwCqoyEF9l
 pqrfqOVn+IyiwmBVpcXfyFHZl5LeHBR
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-26 at 17:33 +0200, Peter Zijlstra wrote:
> On Fri, 2007-10-26 at 17:33 +0200, Kay Sievers wrote:
> > On Fri, 2007-10-26 at 17:22 +0200, Peter Zijlstra wrote:
> > > On Fri, 2007-10-26 at 17:10 +0200, Kay Sievers wrote:
> > > > On Fri, 2007-10-26 at 16:48 +0200, Peter Zijlstra wrote:
> > > > 
> > > > > I appreciate the sysfs people their opinion that /sys/bdi/ might not be the
> > > > > best from their POV, however I'm not seeing where to hook the BDI object from
> > > > > so that it all makes sense, a few of the things are currently not exposed in
> > > > > sysfs at all, like the NFS and FUSE things.
> > > > 
> > > > What happended to the idea to create a "bdi" class, and have the
> > > > existing devices as parents, and for stuff that is not (not now, or
> > > > never) in sysfs, no parent is set.
> > > 
> > > Must have forgotten about that, mainly because I'm not sure I fully
> > > understand it.
> > > 
> > > So we create a class,
> > 
> > Yes.
> > 
> > > create these objects,
> > 
> > Yes, "struct device" objects, assigned to the "bdi" class. (Don't use
> > class_device, that will be removed soon.)
> > 
> > > which are all called bdi
> > 
> > Probably not. You can name it how you want, you can inherit the name of
> > the parent, or prefix it with whatever fits, they just need to be
> > unique. Things like the "fuse-%llu" name would work just fine. I guess
> > you already solved that problem in the debugfs directory.
> > 
> > > and have children with these attributes in it.
> > 
> > The attributes would just be files in the device object.
> > 
> > > Now, I supposed there is a directory that lists all unparented thingies,
> > > how do I locate the one that matches my nfs mount?
> > 
> > You look for the name (prefix), try: "ls /sys/class/sound/", it's the
> > same model all over the place.
> 
> Ok, will try that. Is there a 'simple uncluttered' example I could look
> at to copy from?

drivers/firmware/dmi-id.c

It has only a single device created in the init routine, but it shows
what to do with the class.

Until the block subsystem is converted from using raw kobjects to
devices, you need to set the parent kobject of the bdi device to the
blockdev:
  bdidev->dev.kobj.parent = &disk->kobj

Kay

