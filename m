Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXLFV2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXLFV2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLFV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:27:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXLFV1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:27:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bbpetkov@yahoo.de
Subject: Re: [RFC] swap image signature check upon resume
Date: Thu, 6 Dec 2007 22:46:48 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic>
In-Reply-To: <20071206211335.GA4923@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062246.49422.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of December 2007, Borislav Petkov wrote:
> Hi Pavel,
> hi Rafael,
> 
> after a quick search i couldn't find anything dealing with the topic in the
> subject line so here we go:
> 
> One sometimes can mix up (and by one i mean me) the
> kernel images one boots after having suspended the machine previously. There can
> be at least two reasons for that:
> 
> 1. too many kernels in grub and having forgotten with which i suspended.
> 2. compile and install a new kernel and forget about it, suspend in the evening
> and then boot with the new kernel;
> 
> in both cases you end up staring at fsck since they filesystems haven't been unmounted,
> of course. Or at least see the warning message of some journal recovery whisk away.
> 
> In order to alleviate that, one could probably go, imho, and write in the swsusp_header
> the kernel version which suspended the machine (UTS_RELEASE) alongside
> SWSUSP_SIG and check that against the kernel version of the image just booting.
> If they match then all is well, if not, one could
> 
> a) issue a BIG FAT WARNING and reboot telling the user to select the proper
> image
> b) ask the user what to do:
> 	- proceed as if "noresume" has been entered on the kernel command line
> 	- reboot after issuing the kernel version which suspended the machine
> 	-
> c)...
> 
> In case you guys think something like that might be of use i can come up with a
> patch in the next coupla days...

Well, there's a patchset in the current mainline that allows you to use
arbitrary (sufficiently new) kernel to load the image and then restore the
image kernel.  So, you can hibernate 2.6.24-rc3 and use 2.6.24-rc2 to restore
it, for example.

I'm going to do that for i386 too.

Greetings,
Rafael
