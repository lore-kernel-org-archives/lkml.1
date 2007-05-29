Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbXE2Vpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbXE2Vpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXE2Vpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:45:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39470 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXE2Vpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:45:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Date: Tue, 29 May 2007 23:51:10 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <4658B7DD.3060309@tmr.com> <20070529124052.GH23046@elf.ucw.cz> <1180444425.20718.33.camel@nigel.suspend2.net>
In-Reply-To: <1180444425.20718.33.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705292351.11497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 29 May 2007 15:13, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2007-05-29 at 14:40 +0200, Pavel Machek wrote:
> > On Tue 2007-05-29 14:03:07, Rafael J. Wysocki wrote:
> > > On Tuesday, 29 May 2007 13:29, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > > Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
> > > > > > already?
> > > > > 
> > > > > Yeah, I was thinking about this overnight too. It should be doable. In
> > > > > addition to what we already do, I think you'd want:
> > > > > 
> > > > > - to copy the assembly to do the copying to a safe page;
> > > > > - to put the location of the cpu state that was saved in the image
> > > > > header so that it can be used after the data is copied back;
> > > > 
> > > > ...alternatively, we can just rely on copy routine (and its data) not
> > > > changing frequently.
> > > > 
> > > > > - to copy the nosave data to a 'safe' page.
> > > > > 
> > > > > What else?
> > > > 
> > > > page directories need to be on a safe place, too.
> > > 
> > > They are already.
> > 
> > ...but will that place still be safe when we use other version of
> > kernel?

Yes.

> They'll be in the image too, won't they? Failing that, the information
> could be stored in the image header.

In fact, for each page we have the number of the page frame that it should be
restored to.  Page frame numbers don't change. :-)

> > Anyway, pagedirs are on the safe place, right? That means that we
> > swsusp should no longer clash with page allocation debugging... 
> 
> You mean DEBUG_PAGEALLOC? That can be overcome easily - I have code in
> current Suspend2 that works with DEBUG_PAGEALLOC. I handle the page
> fault, mapping the page and setting a flag in the fault handler to tell
> the atomic copy code to unmap the page again once it has been copied.

Well, I can't comment, I haven't look at that yet.

Greetings,
Rafael
