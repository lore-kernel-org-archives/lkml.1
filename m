Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbYEDQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbYEDQJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYEDQJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:09:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752035AbYEDQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:09:07 -0400
Date: Sun, 4 May 2008 11:09:04 -0500
From: Robin Holt <holt@sgi.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080504160904.GF19717@sgi.com>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org> <200805032253.22765.alistair@devzero.co.uk> <20080504123008.GE19717@sgi.com> <200805041456.14415.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805041456.14415.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 02:56:14PM +0100, Alistair John Strachan wrote:
> On Sunday 04 May 2008 13:30:08 Robin Holt wrote:
> > On Sat, May 03, 2008 at 10:53:22PM +0100, Alistair John Strachan wrote:
> > > On Saturday 03 May 2008 22:47:38 Alistair John Strachan wrote:
> > > > On Saturday 03 May 2008 20:38:20 Linus Torvalds wrote:
> > > > > So go out and test it.
> > >
> > > [snip]
> > >
> > > > Why is this option acting like CONFIG_EMBEDDED and not like basically
> > > > every other subsystem where I can turn ON support for hardware, but by
> > > > default it's OFF? (Obviously in my hasty oldconfig run I just went with
> > > > the default.)
> > >
> > > Amazingly, even if I say Y to this option and disable all tuners, it
> > > still tries (and fails) to compile this file. What is pulling in this
> > > tuner-core dependency?
> >
> > What if you change CONFIG_MEDIA_TUNER to a 'n'
> 
> This isn't a menu-visible option. Your hint does explain why it turns itself 
> on, however:
> 
> config MEDIA_TUNER
>         tristate
>         default DVB_CORE || VIDEO_DEV
>         depends on DVB_CORE || VIDEO_DEV
> 
> I have DVB_CORE=n and VIDEO_DEV=y. VIDEO_DEV is:
> 
> config VIDEO_DEV
>         tristate "Video For Linux"
> 
> So if you enable Video For Linux, the tuner-core is automatically built, even 
> if no tuners are selected? Surely that's wrong..

That is probably correct.  Video For Linux is used for capturing video
streams.  The fact that you can get this invalid config to fail to build
should be reported to the v4l folks and let them fix it up.

VIDEO FOR LINUX
P:      Mauro Carvalho Chehab
M:      mchehab@infradead.org
M:      v4l-dvb-maintainer@linuxtv.org
L:      video4linux-list@redhat.com
W:      http://linuxtv.org
T:      git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
S:      Maintained


Thanks,
Robin
