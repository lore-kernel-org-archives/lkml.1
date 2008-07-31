Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYGaSqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYGaSqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYGaSqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:46:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYGaSqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:46:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: Tree for July 30
Date: Thu, 31 Jul 2008 20:48:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080731141302.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807312048.57575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 of July 2008, Dmitry Torokhov wrote:
> On Thu, Jul 31, 2008 at 10:44:37AM -0700, Andrew Morton wrote:
> > On Thu, 31 Jul 2008 11:56:48 -0400 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Thu, Jul 31, 2008 at 05:36:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Thu, Jul 31, 2008 at 4:07 PM, Dmitry Torokhov
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > > > On Wed, Jul 30, 2008 at 11:10:29PM -0700, Andrew Morton wrote:
> > > > >> On Wed, 30 Jul 2008 17:06:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > >>
> > > > >> > I have created today's linux-next tree at
> > > > >> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > > > >>
> > > > >> The X server broke on my FC8 t61p thinkpad.  Mainline is OK.
> > > > >>
> > > > >> Various information is at http://userweb.kernel.org/~akpm/mo/
> > > > >>
> > > > >> I'm suspecting the input layer - my synaptics device seems to have
> > > > >> disappeared?  See http://userweb.kernel.org/~akpm/mo/Xorg-log-diff.txt
> > > > >>
> > > > >
> > > > > I think this patch should help with Synaptics:
> > > > 
> > > > Which unfortunately doesn't help all people running with older synaptics
> > > > user-space after commit 0571c5d20aca71c735222132b02aebddf593045c
> > > > ("Input: expand keycode space").
> > > > 
> > > > Can't this be solved without breaking Xorg on newer kernels running
> > > > older synaptics?
> > > > 
> > > 
> > > No. The X driver is broken. It tells kernel to use buffer bugger than
> > > allocated and gets its stack smashed. Tslib has also soma funkiness
> > > in the ioctl handling as well... *shrug*
> > > 
> > > We have a couple months to get distros updated...
> > > 
> > 
> > aaarrrrgggggghhh.  I don't think this is practical.  This means that
> > (for example) FC5 machines (of which I happen to have one) are dead. 
> > And lots of other older-distro-based systems.
> > 
> > Is there some userspace workaround which doesn't require an X server
> > update?
> > 
> > Surely it must be possible to make the kernel contiue to support these
> > servers?
> > 
> 
> Andrew,
> 
> It is not like we broke ABI here. The progam (synaptics driver) had a
> grave bug. Older kernels happened to paper over the bug because they
> did not fill the whole buffer that was advertised as available. Now
> that we have more data to report the bug bit us. What do you want me
> to do?
> 
> Synaptics driver is a small package and takes 2 minutes to recompile.
> You don't have to update entire X server with it (in fact I don't think
> it is even part of X distribution because it is GPL).

Well, we're not supposed to break user space that we used to work with, even
if it is known to be buggy.  Many people use the older user space on their
test systems which are not practical to upgrade.

IOW, if the change responsible for this makes it to the mainline kernel, it
will be considered as a regression.

Thanks,
Rafael
