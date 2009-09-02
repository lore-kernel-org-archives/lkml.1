Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZIBXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZIBXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZIBXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:09:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:38833 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZIBXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:09:56 -0400
Date: Wed, 2 Sep 2009 16:09:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rob Landley <rob@landley.net>
cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
In-Reply-To: <200909021800.51096.rob@landley.net>
Message-ID: <alpine.DEB.2.00.0909021605100.28411@asgard.lang.hm>
References: <20090826001645.GN4300@elf.ucw.cz> <20090902201210.GC1840@ucw.cz> <4A9ED8AB.5080003@redhat.com> <200909021800.51096.rob@landley.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Rob Landley wrote:

> USB keys are the modern successor to floppy drives, and even now
> Documentation/blockdev/floppy.txt is still full of some of the torturous
> workarounds implemented for that over the past 2 decades.  The hardware
> existed, and instead of turning up their nose at it they made it work as best
> they could.
>
> Perhaps what's needed for the flash thing is a userspace package, the way
> mdutils made floppies a lot more usable than the kernel managed at the time.
> For the flash problem perhaps some FUSE thing a bit like mtdblock might be
> nice, a translation layer remapping an arbitrary underlying block device into
> larger granularity chunks and being sure to do the "write the new one before
> you erase the old one" trick that so many hardware-only flash devices _don't_,
> and then maybe even use Pavel's crash tool to figure out the write granularity
> of various sticks and ship it with a whitelist people can email updates to so
> we don't have to guess large.  (Pressure on the USB vendors to give us a "raw
> view" extension bypassing the "pretend to be a hard drive, with remapping"
> hardware in future devices would be nice too, but won't help any of the
> hardware out in the field.  I'm not sure that block remapping wouldn't screw up
> _this_ approach either, but it's an example of something that culd be
> _tried_.)
>
> However, thinking about how to _fix_ a problem is predicated on acknowledging
> that there actually _is_ a problem.  "The hardware is not physically damaged
> but your data was lost" sounds to me like a software problem, and thus
> something software could at least _attempt_ to address.  "There's millions of
> 'em, Linux can't cope" doesn't seem like a useful approach.

no other OS avoids this problem either.

I actually don't see how you can do this from userspace, because when you 
write to the device you have _no_ idea where on the device your data will 
actually land.

writing in larger chunks may or may not help, (if you do a 128K write, 
and the device is emulating 512b blocks on top of 128K eraseblocks, 
depending on the current state of the flash translation layer, you could 
end up writing to many different eraseblocks, up to the theoretical max of 
256)

David Lang
