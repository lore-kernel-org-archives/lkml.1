Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYC0Xos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYC0Xos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYC0Xok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:44:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYC0Xok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:44:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: what's the incompatibility between hibernation and hotplug?memory
Date: Fri, 28 Mar 2008 00:44:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47EAD9A7.6020609@goop.org> <200803272155.01463.rjw@sisk.pl> <20080327233852.GA32617@elf.ucw.cz>
In-Reply-To: <20080327233852.GA32617@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803280044.00982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Pavel Machek wrote:
> On Thu 2008-03-27 21:55:01, Rafael J. Wysocki wrote:
> > On Thursday, 27 of March 2008, Jeremy Fitzhardinge wrote:
> > > Pavel Machek wrote:
> > > > Hi!
> > > >
> > > >   
> > > >>> I noticed that Kconfig warns that hibernation and hotplug memory are not 
> > > >>> compatible.  What's the issue?
> > > >>>       
> > > >> Generally, we might not be able to handle memory unplugged at a wrong time
> > > >> (eg. after we've created the image).
> > > >>
> > > >> Which part of Kconfig says that exactly?
> > > >>     
> > > >
> > > > Actually I believe it is simpler than that. We were not prepared to
> > > > deal with memory holes in hibernation code, so we just disabled it in
> > > > Kconfig...
> > > 
> > > Doesn't that mean its generally incompatible with non-flatmem memory 
> > > arrangements rather than hotplug memory specifically?
> > 
> > No, it should work with NUMA nowadays, actually.
> > 
> > Perhaps it's worth trying it with hotplug memory and see what problems arise?
> 
> Good. I believe it is good chance it will work with hotplug, too... as
> long as memory is not inserted/removed during suspend/resume.

Well, there may be a problem if it's inserted after we've created the image
and before powering off, because the resumed kernel will not have any idea of
the new memory.  It probably will require us to add some resume callbacks
for the memory hotplugging to handle this cleanly.

Thanks,
Rafael
