Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbXJHPoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbXJHPoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXJHPo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:44:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbXJHPo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:44:28 -0400
Date: Mon, 8 Oct 2007 08:42:53 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Rob Landley" <rob@landley.net>, "Miguel Ojeda" <maxextreme@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "linux@horizon.com" <linux@horizon.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Message-ID: <20071008084253.407303f0@freepuppy.rosehill>
In-Reply-To: <19f34abd0710080833q76ef905dr6e47a1ec780cf153@mail.gmail.com>
References: <1191528247.13580.11.camel@grianne>
	<200710051126.50816.rob@landley.net>
	<19f34abd0710052310r2043f69ew70fe8b5f9ef0493c@mail.gmail.com>
	<200710071650.50627.rob@landley.net>
	<20071008082541.2638bb34@freepuppy.rosehill>
	<19f34abd0710080833q76ef905dr6e47a1ec780cf153@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 17:33:53 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On 10/8/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > On Sun, 7 Oct 2007 16:50:49 -0500
> > Rob Landley <rob@landley.net> wrote:
> >
> > > On Saturday 06 October 2007 1:10:26 am Vegard Nossum wrote:
> > > > On 10/5/07, Rob Landley <rob@landley.net> wrote:
> > > I made it about halfway through the patch and the only compile time filtering
> > > I found was:
> > >
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -62,7 +62,10 @@
> > > #define MdpMinorShift 6
> > >
> > > #define DEBUG 0
> > > -#define dprintk(x...) ((void)(DEBUG && printk(x)))
> > > +#define dprintk(x...)\
> > > +if(DEBUG) {\
> > > + printk(x);\
> > > +}
> > >
> > > If you say it does, I'll take your word for it, but there's so much churn in
> > > there I didn't find it before my interest ran out...
> > >
> >
> > BTW that change might actually break code (dangling else problems).
> > The original way was safer.
> 
> Yep, thanks. I think containing it in do {} while(0) should fix, though, no?
> 
> Vegard

The correct fix is to just replace dprintk() with pr_debug()

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
