Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYIIP1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYIIP1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYIIP0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:26:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYIIP0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:26:53 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Christoph Hellwig <hch@infradead.org>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Date: Tue, 9 Sep 2008 11:23:56 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080909124608.GA27837@infradead.org>
In-Reply-To: <20080909124608.GA27837@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091123.57109.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 08:46:09 Christoph Hellwig wrote:
> On Tue, Sep 09, 2008 at 12:05:45AM -0400, Jarod Wilson wrote:
> > The following patch series adds 17 new drivers for assorted infrared
> > and/or RF remote control receivers and/or transmitters. These drivers
> > have long lived out-of-tree at http://www.lirc.org/, packaged as
> > 3rd-party modules by many distributions, and more recently, patched into
> > the kernels of at least Fedora and Ubuntu. The primary maintainer of
> > lirc, Christoph Bartelmus simply hasn't had the time to send these bits
> > upstream, and a few months back, gave me the go-ahead to take on the
> > task.
>
> Any reason this is a separate subsystem instead of just a bunch new
> drivers for the input subsystem?

IR device handling is often a bit, shall we say, "special", for a number of 
devices... Some receivers decode the waveform and give us something sensible 
the input layer could use (and some IR receivers do work that way), while 
other receivers pass along raw IR codes, which we require the use of the lirc 
daemon to decode and convert into something sensible. To complicate the matter 
further, a number of devices are either output-only devices, or both input and 
output devices.

There's been talk about converting lirc drivers over to using evdev in the 
long run, but evdev would need a decent amount of extending to be able to 
support everything lircd does right now.

> > Not all drivers have been tested with this codebase and certainly not all
> > devices they support, but its a solid place to start with these
> > in-kernel. Patches are against 2.6.27-rc5-git9 or so, and have been
> > tested running the same, at least in the cases where hardware was
> > available. These patches are also in the latest nightly Fedora rawhide
> > kernel, for those who want instant gratification[3]. Note that you also
> > need the lirc userspace to really do any meaningful testing...
>
> Can you first only send the actually tested drivers?  That way review
> an cleanup can focus on the core and those few and we might get them
> ready for 2.6.28.  Other drivers can than be added when testing and
> review is done.

I meant to include that the ordering of the patches was more or less from 
most-used/most-tested to least-used/least-tested, and a few of the patches do 
include Tested-by: lines in them. Basically, the first four or five drivers 
probably cover the majority of users, so getting them in first would provide 
the most bang-for-your-buck. But I can certainly re-send with only the tested 
drivers after we get through the first round of comments, if that's preferred 
over my approach of putting the higher-prio ones to the front of the ordering.

-- 
Jarod Wilson
jarod@redhat.com

