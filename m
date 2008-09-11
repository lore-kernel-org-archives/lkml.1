Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYIKVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYIKVPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYIKVPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:15:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYIKVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:15:33 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080911205738.GB11708@kroah.com>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com>
	 <1221151165.6309.55.camel@californication>
	 <20080911201541.GA18518@kroah.com>
	 <1221165518.4077.17.camel@macbook.infradead.org>
	 <20080911205738.GB11708@kroah.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 14:15:25 -0700
Message-Id: <1221167725.4077.34.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 13:57 -0700, Greg KH wrote:
> On Thu, Sep 11, 2008 at 01:38:38PM -0700, David Woodhouse wrote:
> > On Thu, 2008-09-11 at 13:15 -0700, Greg KH wrote:
> > > This is the firmware that is in the kernel source tree, that has been
> > > moved to use request_firmware, and was originally tied tightly to the
> > > kernel drivers themselves.
> > 
> > Not really. Most of it hasn't changed for years; it isn't _really_ tied
> > that closely to the kernel. 
> 
> Some are and some aren't (I have two in my -staging tree that are
> changing as the driver changes, so it does happen.)

That's fine. Just make sure the filename changes when an incompatible
change is made to the firmware -- just like you handle sonames in
libraries. It's not hard, and you should _always_ have been doing it.

And it's a completely bogus example _anyway_, because you're not adding
this extra firmware to the kernel tree.

Remember, all recent drivers have been using request_firmware() for
years anyway, and even the older drivers with active and on-the-ball
maintainers have been switching to request_firmware().

All I've done _recently_ is a bit of a sweep on the stragglers. And
because of the amount of stupid whining, I made it possible to keep it
in the kernel tree rather than just evicting it, as we did in the past.

> > You can just ignore what the kernel ships with, and install the firmware
> > from the linux-firmware.git repository instead.
> 
> So you are now forcing distros to ship the linux-firmware.git repo
> instead?  That's not nice and is a totally new dependancy for them to
> handle.

Not at all; that's the ideal situation, but nobody's forced to do it
that way.

> What about the very basic fact that kernel versions will stomp on files
> from other kernel versions if you install multiple kernels on the same
> machine?  That's just bad and ripe for problems in any package
> management system.

Only if you do stupid things in your packaging. So don't do that.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

