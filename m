Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZIOVRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZIOVRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZIOVRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:17:17 -0400
Received: from fifo99.com ([67.223.236.141]:56404 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbZIOVRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:17:17 -0400
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching  the array
From: Daniel Walker <dwalker@fifo99.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090915202445.GC3411@suse.de>
References: <20090915181247.GA32167@kroah.com>
	 <1253041976-1111-6-git-send-email-gregkh@suse.de>
	 <1253043763.11643.358.camel@desktop>
	 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
	 <1253045229.11643.398.camel@desktop>  <20090915202445.GC3411@suse.de>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 14:18:11 -0700
Message-Id: <1253049491.11643.490.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 13:24 -0700, Greg KH wrote:
> On Tue, Sep 15, 2009 at 01:07:09PM -0700, Daniel Walker wrote:
> > On Tue, 2009-09-15 at 21:46 +0200, Kay Sievers wrote:
> > > On Tue, Sep 15, 2009 at 21:42, Daniel Walker <dwalker@fifo99.com> wrote:
> > > > On Tue, 2009-09-15 at 12:12 -0700, Greg Kroah-Hartman wrote:
> > > >> +static const struct memdev {
> > > >> +       const char *name;
> > > >> +       const struct file_operations *fops;
> > > >> +       struct backing_dev_info *dev_info;
> > > >> +} devlist[] = {
> > > >> +       [ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
> > > >
> > > > This patch has several checkpatch errors wrt. the spacing used in the
> > > > array index..
> > > >
> > > > Kay, can you send a follow up patch to correct them?
> > > 
> > > I think they are fine, and properly aligned to be best readable.
> > 
> > We already have a coding style in Linux which doesn't allow this type of
> > alignment .. If we allowed everyone to pick their own coding style we
> > would have a pretty ugly looking kernel.. That's why the checkpatch tool
> > was create to test for style conformance.. If you feel strongly about
> > this alignment you could change checkpatch not to warn on this , but I
> > don't think it's likely a change like that would be accepted..
> 
> I explicitly ignored the checkpatch warnings here, as Kay is right, it
> does look better and is more sane with the way he wrote it.
> 
> Remember, checkpatch.pl is a _guide_ not a
> hard-and-fast-rule-or-else-puppies-will-get-hurt type of a thing.
> 
> The whole reason for having a consistant coding style is so your brain
> gets used to patterns and you can see the context of the code instead.
> It's a proven thing.  Arguing that removing that space makes it easier
> to understand and maintain over time is illogical.

I agree It can depend on context , but I don't agree that it's needed
here..

In this case space or no space it really doesn't matter, since half the
lines are spaced with ifdefs ..

So it boils down to just these lines,

+       [ 5] = { "zero", &zero_fops, &zero_bdi },
+       [ 6] = { "full", &full_fops, NULL },
+       [ 7] = { "random", &random_fops, NULL },
+       [ 9] = { "urandom", &urandom_fops, NULL },
+       [11] = { "kmsg", &kmsg_fops, NULL },

or properly formatted like this,

+       [5] = { "zero", &zero_fops, &zero_bdi },
+       [6] = { "full", &full_fops, NULL },
+       [7] = { "random", &random_fops, NULL },
+       [9] = { "urandom", &urandom_fops, NULL },
+       [11] = { "kmsg", &kmsg_fops, NULL },

I don't see a stark difference. Now you have to contend with the fact
that checkpatch spews errors on these lines .. If your going to allow
errors you better be getting your moneys worth since you'll have to
defend them , and ignore patches to clean them up.

In terms of maintaining these actual lines of code, I don't think it
matters either.. However, the more style errors you allow into a tree
the more clean up patches you will have to ignore, or explain away..
Which is all just wasted work either by you or others that could be
better spent doing other stuff .. In general I think everything should
be style clean unless there is a concrete reason not to be..

Daniel

