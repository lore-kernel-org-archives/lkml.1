Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYAZFgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYAZFgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYAZFgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:36:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:59996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbYAZFgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:36:39 -0500
Date: Fri, 25 Jan 2008 21:33:26 -0800
From: Greg KH <gregkh@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Volker Sameske <sameske@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH 085/196] kset: convert s390 ipl.c to use kset_create
Message-ID: <20080126053326.GB27403@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-6-git-send-email-gregkh@suse.de> <20080125122052.GA9080@osiris.ibm.com> <20080125174858.GB4242@suse.de> <20080125231017.GA20351@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125231017.GA20351@osiris.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 12:11:33AM +0100, Heiko Carstens wrote:
> On Fri, Jan 25, 2008 at 09:48:58AM -0800, Greg KH wrote:
> > On Fri, Jan 25, 2008 at 01:20:53PM +0100, Heiko Carstens wrote:
> > > On Thu, Jan 24, 2008 at 11:31:54PM -0800, Greg Kroah-Hartman wrote:
> > > > Dynamically create the kset instead of declaring it statically.
> > > > This makes the kobject attributes now work properly that I broke in the
> > > > previous patch.
> > > 
> > > Could you please merge this and the previous patch before it goes
> > > upstream? Having an intermediate state where things are broken
> > > will cause pain and additional work in case of bisecting.
> > 
> > It will not cause a build error (see the previous patch for details.)
> > The sysfs files will not properly show the correct data, that is all.
> >
> > The odds that you will hit this in a 'git bisect' is VERY low, and the
> > previous patch states that the files are now broken, so there should not
> > be any confusion regarding any user that might run across this.
> 
> The odds are very low, as long as not more patch sets come up which
> introduce intermediate broken kernels.
> What exactly is the advantage of breaking the kernel with patch 1 and
> then fix it again with patch 2 instead of doing the straight forward
> conversions all with one patch?

I was trying to do one logical thing at a time with this driver as I did
not have the hardware to test, and I could not even build the code at
the time.

In looking more closer, I think the 084 patch might still work properly,
but I can't guarantee it as the the default kobject parent might not be
pointing to the correct attribute at the time.  I know 085 fixes this to
be sure that it will work properly.

It helped in reviewing this code by the other s390 developers to have
this in at least 2 pieces, to try to untangle the mess of sysfs files,
ksets, and other attrocities that you all have grown into over the
years.

So again, I'm sorry if this happens to break your run-time tests when
doing a 'git bisect', but as I explicitly stated it did in the patch, I
think everyone is properly forwarned :)

This core rework was tough to do, there was a reason no one had done it
before.  Now it is cleaner, smaller, able to be understood by at least
one active kernel developer, if not more, and it's documented, with
working examples.  If the downside of this effort is only this one thing
(note that others are finally finding real bugs...) I'll be very happy.

thanks,

greg k-h
