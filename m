Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZFWSaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZFWSaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZFWS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:29:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZFWS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:29:51 -0400
Date: Tue, 23 Jun 2009 20:29:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090623182941.GA2045@elf.ucw.cz>
References: <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FC84A.6060608@gmail.com> <20090622204031.GA24236@elf.ucw.cz> <4A3FFC89.4070006@am.sony.com> <20090622215753.GA25434@elf.ucw.cz> <4A4119DB.4030203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4119DB.4030203@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-23 20:07:23, Marco wrote:
> Pavel Machek wrote:
> > On Mon 2009-06-22 14:50:01, Tim Bird wrote:
> >> Pavel Machek wrote:
> >>>> block of fast non-volatile RAM that need to access data on it using a
> >>>> standard filesytem interface."
> >>> Turns a block of fast RAM into 13MB/sec disk. Hmm. I believe you are
> >>> better with ext2.
> >> Not if you want the RAM-based filesystem to persist over a kernel
> >> invocation.
> > 
> > Yes, you'll need to code Persistent, RAM-based _block_device_. 
> 
> First of all I have to say that I'd like to update the site and make it
> clearer but at the moment it's not possible because I'm not the admin
> and I've already asked to the sourceforge support to have this possibility.
> 
> About the comments: sincerely I don't understand the comments. We have
> *already* a fs that takes care to remap a piace of ram (ram, sram,
> nvram, etc.), takes care of caching problems, takes care of write

Well, it looks pramfs design is confused. 13MB/sec shows that caching
_is_ useful for pramfs. So...?

> You are talked about journaling. This schema works well for a disk, but
> what about a piece of ram? What about a crazy kernel that write in that
> area for a bug? Do you remember for example the e1000e bug? It's not

I believe you need both journaling *and* write protection. How do you
handle power fault while writing data?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
