Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYEDN4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYEDN4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYEDN4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:56:18 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:53745 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756236AbYEDN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:56:17 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Robin Holt <holt@sgi.com>
Subject: Re: Linux 2.6.26-rc1
Date: Sun, 4 May 2008 14:56:14 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org> <200805032253.22765.alistair@devzero.co.uk> <20080504123008.GE19717@sgi.com>
In-Reply-To: <20080504123008.GE19717@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805041456.14415.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008 13:30:08 Robin Holt wrote:
> On Sat, May 03, 2008 at 10:53:22PM +0100, Alistair John Strachan wrote:
> > On Saturday 03 May 2008 22:47:38 Alistair John Strachan wrote:
> > > On Saturday 03 May 2008 20:38:20 Linus Torvalds wrote:
> > > > So go out and test it.
> >
> > [snip]
> >
> > > Why is this option acting like CONFIG_EMBEDDED and not like basically
> > > every other subsystem where I can turn ON support for hardware, but by
> > > default it's OFF? (Obviously in my hasty oldconfig run I just went with
> > > the default.)
> >
> > Amazingly, even if I say Y to this option and disable all tuners, it
> > still tries (and fails) to compile this file. What is pulling in this
> > tuner-core dependency?
>
> What if you change CONFIG_MEDIA_TUNER to a 'n'

This isn't a menu-visible option. Your hint does explain why it turns itself 
on, however:

config MEDIA_TUNER
        tristate
        default DVB_CORE || VIDEO_DEV
        depends on DVB_CORE || VIDEO_DEV

I have DVB_CORE=n and VIDEO_DEV=y. VIDEO_DEV is:

config VIDEO_DEV
        tristate "Video For Linux"

So if you enable Video For Linux, the tuner-core is automatically built, even 
if no tuners are selected? Surely that's wrong..

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
