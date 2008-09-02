Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYIBATZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYIBATZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYIBATJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:19:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22758 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYIBATH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:19:07 -0400
Date: Mon, 1 Sep 2008 18:19:05 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Zhao, Yu" <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       Greg KH <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Message-ID: <20080902001905.GB14492@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, "Zhao, Yu" <yu.zhao@intel.com>,
	jbarnes@virtuousgeek.org, Greg KH <gregkh@suse.de>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com> <20080830053755.GA16219@suse.de> <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com> <7A25B56E4BE99C4283EB931CD1A40E110177E4DA@pdsmsx414.ccr.corp.intel.com> <20080901184018.GA14492@ldl.fc.hp.com> <20080902000951.GM1239@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902000951.GM1239@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Mon, Sep 01, 2008 at 12:40:18PM -0600, Alex Chiang wrote:
> > We get the "slot already scheduled for removal" because that
> > particular device has 2 functions, and we're creating slots
> > on a per-slot basis now, not a per-function basis.
> > 
> > Although, I wonder, Willy -- is that really the right thing
> > to do? Seems like fakephp would be more useful if we did
> > operate on a per-function basis, and not per-slot. Especially
> > given Yu's work with SR-IOV, where we can apparently have
> > lots of functions per a physical device.
> 
> I suspect it depends on what you believe the point of fakephp
> is.  

Ok, this was all developed before I started working in this area,
or Linux, even. ;)

> My assumption was that it was a way to fake what would happen
> if you had a hotplug controller for a particular slot.  In that
> context, the change I made was clearly correct.  If you want to
> use it for hot-removing individual functions from a Linux guest
> running under a hypervisor (for example), that's much less
> useful.

Sure, that sounds reasonable.

In that case, my patch should fix the stupid regression I
introduced, but if others think that fakephp would be more useful
for hot-removing functions, I wouldn't object to reverting the
original patch.

Thanks.

/ac

