Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbZC0B2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbZC0B2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZC0B2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:28:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603AbZC0B2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:28:18 -0400
Date: Thu, 26 Mar 2009 18:25:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090326182519.d576d703.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<49C88C80.5010803@krogh.cc>
	<72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 18:03:15 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 26 Mar 2009, Andrew Morton wrote:
> > 
> > userspace can get closer than the kernel can.
> 
> Andrew, that's SIMPLY NOT TRUE.
> 
> You state that without any amount of data to back it up, as if it was some 
> kind of truism. It's not.

I've seen you repeatedly fiddle the in-kernel defaults based on
in-field experience.  That could just as easily have been done in
initscripts by distros, and much more effectively because it doesn't
need a new kernel.  That's data.

The fact that this hasn't even been _attempted_ (afaik) is deplorable.

Why does everyone just sit around waiting for the kernel to put a new
value into two magic numbers which userspace scripts could have set?

My /etc/rc.local has been tweaking dirty_ratio, dirty_background_ratio
and swappiness for many years.  I guess I'm just incredibly advanced.

> Everybody accepts that if you've written a 20MB file and then call 
> "fsync()" on it, it's going to take a while. But when you've written a 2kB 
> file, and "fsync()" takes 20 seconds, because somebody else is just 
> writing normally, _that_ is a bug. And it is actually almost totally 
> unrelated to the whole 'dirty_limit' thing.
> 
> At least it _should_ be. 

That's different.  It's inherent JBD/ext3-ordered brain damage. 
Unfixable without turning the fs into something which just isn't jbd/ext3
any more.  data=writeback is a workaround, with the obvious integrity
issues.

The JBD journal is a massive designed-in contention point.  It's why
for several years I've been telling anyone who will listen that we need
a new fs.  Hopefully our response to all these problems will soon be
"did you try btrfs?".

