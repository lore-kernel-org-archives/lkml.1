Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZFXRre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZFXRre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbZFXRrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:47:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33826 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761043AbZFXRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:47:03 -0400
Date: Wed, 24 Jun 2009 19:46:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: tim.bird@am.sony.com, jamie@shareable.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090624174657.GA6618@elf.ucw.cz>
References: <4a4254e2.09c5660a.109d.46f8@mx.google.com> <4A425907.2060105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A425907.2060105@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 18:49:11, Marco wrote:
> >> Pavel Machek wrote:
> >>> On Mon 2009-06-22 14:50:01, Tim Bird wrote:
> >>>> Pavel Machek wrote:
> >>>>>> block of fast non-volatile RAM that need to access data on it using a
> >>>>>> standard filesytem interface."
> >>>>> Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
> >>>>> better with ext2.
> >>>> Not if you want the RAM-based filesystem to persist over a kernel
> >>>> invocation.
> >>> Yes, you'll need to code Persistent, RAM-based _block_device_. 
> >> First of all I have to say that I'd like to update the site and make it
> >> clearer but at the moment it's not possible because I'm not the admin
> >> and I've already asked to the sourceforge support to have this possibility.
> >>
> >> About the comments: sincerely I don't understand the comments. We have
> >> *already* a fs that takes care to remap a piace of ram (ram, sram,
> >> nvram, etc.), takes care of caching problems, takes care of write
> > 
> > Well, it looks pramfs design is confused. 13MB/sec shows that caching
> > _is_ useful for pramfs. So...?
> 
> caching problems means to avoid filesystem corruption, so dirty pages in
> the page cache are not allowed to be written back to the backing-store
> RAM. It's clear that there is a performance penalty. This penalty should
> be reduced by the access speed of the RAM, however the performance are
> not important for this special fs as Tim Bird said, so this question is
> not relevant for me. If this issue is not clear enough on the web site,
> I hope I can update the information in the future.

Yes, please update the pages...

> >> You are talked about journaling. This schema works well for a disk, but
> >> what about a piece of ram? What about a crazy kernel that write in that
> >> area for a bug? Do you remember for example the e1000e bug? It's not
> > 
> > I believe you need both journaling *and* write protection. How do you
> > handle power fault while writing data?
> 
> Ah now the write protection is a "needed feature", in your previous
> comment you talked about why not use ext2/3.......

write protection should be handled at block device layer, not
filesystem layer. So yes, use ext2.

You still did not explain how you avoid the need for journalling...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
