Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXLION2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXLION2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXLIONV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:13:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXLIONU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:13:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bbpetkov@yahoo.de
Subject: Re: [RFC] swap image signature check upon resume
Date: Sun, 9 Dec 2007 15:32:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <20071209065559.GA4627@gollum.tnic> <200712091527.57523.rjw@sisk.pl>
In-Reply-To: <200712091527.57523.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091532.28417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Rafael J. Wysocki wrote:
> On Sunday, 9 of December 2007, Borislav Petkov wrote:
> > On Sat, Dec 08, 2007 at 11:50:33PM +0100, Rafael J. Wysocki wrote:
> > > On Saturday, 8 of December 2007, Borislav Petkov wrote:
> > > > On Fri, Dec 07, 2007 at 09:19:09PM +0100, Rafael J. Wysocki wrote:
> > > > 
> > > > ...
> > > > 
> > > > > > > Well, there's a patchset in the current mainline that allows you to use
> > > > > > > arbitrary (sufficiently new) kernel to load the image and then restore the
> > > > > > > image kernel.  So, you can hibernate 2.6.24-rc3 and use 2.6.24-rc2 to restore
> > > > > > > it, for example.
> > > > > > > 
> > > > > > > I'm going to do that for i386 too.
> > > > > > right, this is d307c4a8e826c44f9633bd3f7e60d0491e7d885a (Hibernation: Arbitrary
> > > > > > boot kernel support - generic code), i should've seen that. What's the status of
> > > > > > those bits, from a quick scan it seems they need some rewiring (Kconfig, e.g.
> > > > > > CONFIG_ARCH_HIBERNATION_HEADER etc..) and arch-specific save and restore
> > > > > > functions?
> > > > > 
> > > > > No, this code is fully functional. :-)
> > > > > 
> > > > > The arch save and restore functions are in arch/x86/kernel/suspend_64.c .
> > > > > 
> > > > > As I said, i386 is not yet supported.
> > > > 
> > > > nice, holler if you need a tester when you have some prototypes ready. By the way,
> > > > what do you do when the suspend image header mismatches and it is unsafe to continue booting?
> > > 
> > > If the image header doesn't match, we don't load it and return an error code,
> > > which usually results in the boot kernel continuing to boot.
> > 
> > But if you continue to boot the filesystems were still mounted and fsck has to
> > go over them and check for errors. In the case of ext2 this takes relatively
> > long depending on the size of the partition. However, this is only the
> > smaller problem, the problem of data loss is what worries me.
> 
> The filesystems are synced before the hibernation, so there shouldn't be data
> any loss.

s/data any loss/any data loss/ (sorry).
