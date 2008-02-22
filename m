Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYBVMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYBVMEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYBVME2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:04:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:60713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYBVME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:04:27 -0500
Date: Fri, 22 Feb 2008 13:04:12 +0100
From: Karsten Keil <kkeil@suse.de>
To: Simon Richter <sjr@debian.org>
Cc: Tilman Schmidt <tilman@imap.cc>, Jeff Garzik <jeff@garzik.org>,
       kkeil@suse.de, Greg KH <greg@kroah.com>,
       Gregory Nietsky <gregory@networksentry.co.za>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       isdn4linux@listserv.isdn4linux.de, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080222120412.GA11916@pingi.kke.suse.de>
Mail-Followup-To: Simon Richter <sjr@debian.org>,
	Tilman Schmidt <tilman@imap.cc>, Jeff Garzik <jeff@garzik.org>,
	kkeil@suse.de, Greg KH <greg@kroah.com>,
	Gregory Nietsky <gregory@networksentry.co.za>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	isdn4linux@listserv.isdn4linux.de, Sam Ravnborg <sam@ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BD5360.5070706@debian.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry that I step in so late, procmail sorted this thread in the wrong
box.
Normally I reserved the complete last week for working on mISDN to get it
ready to submit it to -mm, but reality did hit me and I had to do some
other importent stuff :-(

On Thu, Feb 21, 2008 at 11:33:04AM +0100, Simon Richter wrote:
> Hi,
> 
> Tilman Schmidt wrote:
> 
> > mISDN has two problems, which are of course interrelated:
> 
> mISDN has one problem that is even bigger than these: the kernel oopses 
> if modules aren't loaded in the right order. misdn-init works around 
> that, but if it doesn't work for some reason (and I can think of 
> multiple here), the user is left with a kernel that oopses during 
> hardware discovery and never gets to a stage where this can be 
> rectified, as almost all distributions now have hardware discovery 
> before the first opportunity to get a shell. At least these were my 
> experiences the last time I tried it on my test box.
> 
> This is the reason I've kept mISDN out of the last two Debian stable 
> releases, despite users' requests.
> 
> When a hardware driver module is loaded, it should only do basic 
> hardware initialisation; it is certainly not necessary to set up the 
> entire stack (or even decide on a protocol, which currently needs to be 
> handed in via module parameter -- before userland code is there that 
> wants to talk to the hardware, there is no reason to have the hardware 
> active).
> 

These design issues are fixed in the new mISDN socket branch.
The old mISDN design was too complicated because it allow access to
every layer and build the ISDN stack dynamically, both feature were never
needed in practice and contain many race conditions.
The new design only has one core module and hardware specific modules
with a very simple interface.
The interface to the userspace are sockets (one per channel).

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
