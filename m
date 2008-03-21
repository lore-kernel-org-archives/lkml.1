Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYCUOGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYCUOGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYCUOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:05:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1847 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753460AbYCUOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:05:38 -0400
Date: Fri, 21 Mar 2008 14:17:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ?ric Piel <Eric.Piel@tremplin-utc.net>, Tilman Schmidt <tilman@imap.cc>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Message-ID: <20080321131737.GC5331@ucw.cz>
References: <1205517802.12763.18.camel@nimitz.home.sr71.net> <1205525184.12763.32.camel@nimitz.home.sr71.net> <47DAE55C.3080506@tremplin-utc.net> <1205530551.8167.20.camel@nimitz.home.sr71.net> <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > It's a pity, I had just nearly finished a new approach. Instead of
> > relying on populate_rootfs() and the filesystem infrastructure, the new
> > approach directly finds the file in the initramfs.
> 
> So that avoids the VFS layer issues, but it's still strictly much worse 
> than just having a run-time loading.
> 
> What's the problem with just loading a new DSDT later? Potentially as in 
> *much* later: including when user-space is all up-and-running? 
> 
> For things like DVD install images, you'd quite possibly want to have a 
> few known-workaround DSDT images with the installer, and just say "ok, we 
> want to fix up this ACPI crap in order to get working suspend/resume" kind 
> of thing.
> 
> So what's the reason for pushing for this insanely-early workaround in the 
> first place, instead of letting user-space do something like
> 
> 	cat my-dsdt-image > /proc/sys/acpi/DSDT
> 
> or whatever at runtime?

You have interpretted code runing (AML), and you want to replace it
with different code?

Akin to changing from one kernel to different during runtime?

Yes, I guess it might work for very simple changes, but if you need to change
data structures between origina and modified DSDT, you are in for a
big trouble, right?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
