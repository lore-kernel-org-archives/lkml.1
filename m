Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZBITei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZBITei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbZBITeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:34:03 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54216 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbZBITeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:34:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices, and make consequential changes to maple input drivers - 2/3 - v5
Date: Mon, 9 Feb 2009 14:33:55 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>
References: <1234122069.6736.8.camel@localhost.localdomain> <20090209065632.GA21980@linux-sh.org> <1234207053.6756.11.camel@localhost.localdomain>
In-Reply-To: <1234207053.6756.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091433.57126.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 14:17:33 Adrian McMenamin wrote:
> On Mon, 2009-02-09 at 15:56 +0900, Paul Mundt wrote:
> > On Sun, Feb 08, 2009 at 08:04:33PM +0000, Adrian McMenamin wrote:
> > > Change the maple bus driver to support the visual memory unit driver.
> > >
> > > The maple bus driver currently only supports synchronous polling of
> > > attached devices status. These changes allow the bus to handle
> > > asynchronous commands such as block reads and writes.
> > >
> > > Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> >
> > The ordering of your patch series is a bit vague. Do the changes to the
> > maple bus code need to be made before the VMU patch can be applied? Do
> > the input driver changes have to be made at the same time as the changes
> > to the bus code, or are they ok to leave as a separate patch after the
> > bus changes?
> >
> > All of these seem to have some interdependency issues that haven't been
> > noted at all, making it incredibly difficult to apply incrementally. Your
> > subject for the series also seems to imply you have no idea how they
> > logically structure, and that you simply hacked things up until the point
> > where everything worked, rather than paying attention to logical
> > incremental changes to show how you got from point A to point B without
> > breaking bisection along the way.
>
> You are right. I haven' made it fully clear in this post. But I did in
> previous posts eg:
>
> "This series of patches adds support for the Dreamcast Visual Memory
> Unit, reworking the maple bus code to ensure it supports asynchronous
> reads and writes. A consequential amendment to the keyboard driver is
> also included."

that isnt terribly clear.  it might be for you, but for the people attempting 
to coordinate source code, it really isnt.

using git, you can format patches and number them and include a cover letter.  
that would make everything clear for people.
git format-patch -n --cover-letter HEAD~3

then you'd end up with 4 clearly marked files (assuming your log message for 
each change is clear).  in the summary, you should then make statements like:
Patch 1 (... subject ...) in this series can be applied by itself for the bus 
driver.  Then patch 2 (... subject ...) and 3 (... subject ...) can be applied 
as they need the bus changes.
-mike
