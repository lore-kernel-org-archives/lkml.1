Return-Path: <linux-kernel-owner+w=401wt.eu-S1763734AbXEYQf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763734AbXEYQf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXEYQfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:35:22 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760790AbXEYQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:35:20 -0400
Date: Fri, 25 May 2007 09:33:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Newport <crn@netunix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-Id: <20070525093354.5dbe5f43.akpm@linux-foundation.org>
In-Reply-To: <20070525123456.GA17238@elte.hu>
References: <46558708.2040803@googlemail.com>
	<46559B54.80106@googlemail.com>
	<Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
	<20070524193740.GA6787@elte.hu>
	<alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
	<20070525101105.GA9268@elte.hu>
	<4656CE39.8050800@netunix.com>
	<20070525123456.GA17238@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 14:34:56 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> * Chris Newport <crn@netunix.com> wrote:
> 
> > There is a fundamental problem in getting a decent log to debug a 
> > crashed kernel.  Maybe we should take a hint from Solaris. If the 
> > kernel crashes Solaris dumps core to swap and sets a flag. At the next 
> > boot this image is copied to /var/adm/crashdump where it is preserved 
> > for future debugging. Obviously swap needs to be larger than core, but 
> > this is usually the case.
> 
> we've got kdump, but it's not usually enabled by default by distros.

Isn't that awful?

By now we should be in the situation where if a tester is hitting a
kernel crash we can say to them "please turn on crashdumps and send me
the image".  But we're not - kernel developers don't know how to turn the
thing on in $RANDOM_DISTRO, testers have no experience with the feature
and kernel developers don't have experience handling the crash images.

And I'm not sure that the (required) "don't dump user memory and pagecache"
feature has been implemented yet?

It'd be in our interests to push all this along a bit.
