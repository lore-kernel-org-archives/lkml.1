Return-Path: <linux-kernel-owner+w=401wt.eu-S1764925AbXFSAGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764925AbXFSAGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbXFSAGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:06:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608AbXFSAGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:06:40 -0400
Date: Mon, 18 Jun 2007 17:06:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <20070618164711.9de1c38e.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706181700280.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
 <20070618164711.9de1c38e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Andrew Morton wrote:

> On Mon, 18 Jun 2007 14:14:30 -0700
> Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> > Andrew,
> > 
> > The default vm_dirty_ratio changed from 40 to 10
> > for the 2.6.22-rc kernels in this patch:

Yup.

> > IOZone write drops by about 60% when test file size is 50 percent of
> > memory.  Rand-write drops by 90%. 
> 
> heh.
> 
> (Or is that an inappropriate reaction?)

I think it's probably appropriate.

I don't know what else to say.

For pure write testing, where writeback caching is good, you should 
probably run all benchmarks with vm_dirty_ratio set as high as possible. 
That's fairly obvious.

What's equally obvious is that for actual real-life use, such tuning is 
not a good idea, and setting the vm_dirty_ratio down causes a more 
pleasant user experience, thanks to smoother IO load behavoiur.

Is it good to keep tons of dirty stuff around? Sure. It allows overwriting 
(and thus avoiding doing the write in the first place), but it also allows 
for a more aggressive IO scheduling, in that you have more writes that you 
can schedule.

It does sound like IOZone just isn't a good benchmark. It doesn't actually 
measure disk throughput, it really measures how good the OS is at *not* 
doing the IO. And yes, in that case, set vm_dirty_ratio high to get better 
numbers.

I'd rather have the defaults at something that is "pleasant", and then 
make it easy for benchmarkers to put it at something "unpleasant, but 
gives better numbers". And it's not like it's all that hard to just do

	echo 50 > /proc/sys/vm/dirty_ratio

in your /etc/rc.local or something, if you know you want this.

Maybe somebody can make a small graphical config app, and the distros 
could even skip it? Dunno. I *suspect* very few people actually end up 
caring.

			Linus
