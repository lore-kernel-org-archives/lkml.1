Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbXHJVZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbXHJVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXHJVZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:25:11 -0400
Received: from antonio.urjc.es ([193.147.184.24]:43763 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbXHJVZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:25:08 -0400
Message-ID: <46BCD7AA.5080407@urjc.es>
Date: Fri, 10 Aug 2007 23:24:58 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       GregKH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es> 
		<20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com> 
		<46B7832B.6010808@urjc.es> <20070807125844.4d756b04@gondo 
		l	in.boeblingen.de.ibm.com> <3ae72650708070446y6452d13jb7cd802119dab3ce@ma
	 	il	  .gmail.com> <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 	<46B869	 C6.3090708@urjc.es><1186491472.3611.33.camel@lov.localdomain> 
		<46B87ACA.7010 501@urjc.es> 
		<20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com> 
		<46BAE005.4000906@urjc.es> <1186660716.21247.94.camel@lov.localdomain>
In-Reply-To: <1186660716.21247.94.camel@lov.localdomain>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Fri, 10 Aug 2007 
	23:24:52 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-17.6942 TC:1F TRN:50 TV:3.6.1039(15354.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09 Aug 2007, Kay Sievers wrote:

> On Thu, 2007-08-09 at 11:36 +0200, Javier Pello wrote:
> 
> > Anyway, my point is that it is useless to have the kernel block for
> > a minute at boot waiting for something that cannot happen, and that
> > it should be avoided (even if my proposed solution is not the way
> > to go).
> 
> That's true. And it sounds all reasonable from your point of view,
> and the firmware loader needs fixing, and the silly blocking request
> needs to be removed from the kernel, that's known for a very long
> time now, but nobody did the work so far.

If I see it correctly, your point is that the firmware loader is
totally broken and needs replacing. That's fine, and I won't say
otherwise. But it doesn't seem that such replacement is under way
and, in the meanwhile, we are stuck with what we have. I'm not
defending the current loader but, while we have it, we might as
well not have it freeze the whole kernel for a minute waiting
for something that won't happen.

> But in this specific case, it is more the combination of your
> options, what causes this problem to appear. You don't have an
> initramfs, you don't use modules, but you are linking a driver
> into the kernel image which depends on a conceptually broken
> blocking userspace transaction to initialize.
> This combination of options just doesn't make sense. Either
> use initramfs, or use a kernel module for the driver that needs
> userspace to initialize, or patch the driver not to block in
> the request, or patch the driver to optionally include the
> firmware in the driver.

Note that the problem is not getting the driver to work---I can
do that pretty easily. The problem is that there's a number of
drivers that, just because they require firmware, will hang the
kernel on boot if built in unless an initramfs is carefully
prepared. An allyesconfig kernel could freeze for 10 minutes
during boot just because it came across 10 devices requiring
firmware, even if you don't intend to use them.

> You just picked a set of options that doesn't work nicely
> together.

I agree. That's why I sent the patch, to make it work better.

> No distro setup has this problem, that's probably why nobody
> really cared and it didn't get fixed so far.

I agree again. But the fact that it didn't get fixed so far
doesn't mean that it can never get fixed, does it?

Also, note that I'm not proposing massive changes, or changes
that will break things for other people (not intentionally,
anyway), or that will add complexity and unmaintainability
to the kernel. They try to do a reasonable thing and are
small and to the point.

Javier


