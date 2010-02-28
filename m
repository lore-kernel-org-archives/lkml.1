Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936618Ab0B1TwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:52:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463Ab0B1TwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:52:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() messages
Date: Sun, 28 Feb 2010 20:54:32 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
References: <201002272143.22156.rjw@sisk.pl> <201002281313.38483.rjw@sisk.pl> <1267374785.1929.2.camel@i7.satnam>
In-Reply-To: <1267374785.1929.2.camel@i7.satnam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002282054.32204.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
> Hello Rafael,
> 
> On Sun, 2010-02-28 at 13:13 +0100, Rafael J. Wysocki wrote:
> > On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
> > > On Sun, Feb 28, 2010 at 2:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > >
> > > > The messages from _request_firmware() informing that firmware is
> > > > being requested or built-in firmware is going to be used are printed
> > > > at KERN_INFO, which produces lots of noise on systems with huge
> > > > numbers of AMD CPUs.  Reduce the level of these messages to
> > > > KERN_DEBUG to get rid of that noise.
> > > >
> > > 
> > > Which firmware we are using is very useful information. Because of
> > > huge numbers of CPUs it seems noise then better provide the
> > > information for first cpu and for the rest of the CPUs you can show by
> > > KERN_DEBUG.
> > 
> > That would have been better indeed, but the problem is _request_firmware()
> > doesn't allow us to change the level of its messages on demand.
> 
> Can we try this :
> 
> 	if (smp_processor_id())
> 		dev_dbg(..);
> 	else
> 		dev_info(..);

Well, it doesn't look particularly nice, does it?

Besides, say we're requesting firmware for a non-CPU device which happens
to run on CPU1.  Then, dev_dbg() will be used, which most likely is not what we
want.

Rafael
