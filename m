Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbXEURNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbXEURNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXEURNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:13:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbXEURNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:13:10 -0400
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
From: Kay Sievers <kay.sievers@vrfy.org>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Ken Chen <kenchen@google.com>, Ray Lee <ray-lk@madrabbit.org>,
       Al Viro <viro@ftp.linux.org.uk>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200705211851.00187.uwe.bugla@gmx.de>
References: <464F42F3.1080300@madrabbit.org>
	 <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
	 <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
	 <200705211851.00187.uwe.bugla@gmx.de>
Content-Type: text/plain
Date: Mon, 21 May 2007 19:11:06 +0200
Message-Id: <1179767466.3320.48.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Am/EF90qLB7c+NAxpEzaeYYikRZybet8UyA4
 w4lhuZFGAD6p8EhSsX3Uq1hod5vgSEpC3zc4Qag4H7RUWTUImP
 y+sFpzgJiJHQjLPpbej/v17oahVUyfN
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 18:50 +0200, Uwe Bugla wrote:
> Am Montag, 21. Mai 2007 18:37 schrieben Sie:
> > On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> > > yes and no. in that commit, I automatically create n+1 device when
> > > loop device n is created, allergically was tested to be fine with
> > > casual usage of "losetup" and "mount -o loop".  However, there is a
> > > bug in that commit when loop.c was compiled as a module.  And when Al
> > > fixed it, he also removed that magic "n+1" trick.
> > >
> > > Nevertheless, yes, I'm guilty of introducing the new behavior.
> >
> > The easiest way is to reinstate max_loop and create "max_loop" device
> > up front at module load time.  However, that will lose all the "fancy
> > on-demand device instantiation feature".
> >
> > So I propose we do the following:
> >
> > 1. have the module honor "max_loop" parameter and create that many
> > device upfront on module load (max_loop will also be a hard max) iff
> > user specify the parameter.
> > 2. if max_loop is not specified, default create 8 loop device.  User
> > can extent more loop device by create device node themselves and have
> > kernel automatically instantiate loop device on-demand.
> 
> Sorry, Ken:
> My question on point 2 would be: Does "User can extent more loop device by 
> create device node themselves and......." correspond or conflict to working 
> with udev?

Udev shouldn't care if the kernel tells udev about the new device, and
the node with the correct dev_t is already there, it will leave it as it
is, and only apply the configured user,group,mode values.

The loop tools should probably extended to be able to request new
devices from the kernel in a different way than open().

Kay

