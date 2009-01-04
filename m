Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZADFC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZADFC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 00:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbZADFCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 00:02:19 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:42094 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZADFCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 00:02:19 -0500
Date: Sat, 3 Jan 2009 21:02:15 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
In-Reply-To: <1231019614.15389.104.camel@pasglop>
Message-ID: <Pine.LNX.4.58.0901031827380.25853@shell2.speakeasy.net>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org> 
 <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
 <1231019614.15389.104.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Benjamin Herrenschmidt wrote:
> On Sat, 2009-01-03 at 09:10 -0800, Linus Torvalds wrote:
> >
> > On Sat, 3 Jan 2009, Trent Piepho wrote:
> > >
> > > Have %pR print "[NULL]" for the resource range when passed a NULL pointer.
> >
> > Wouldn't it be much nicer to just do it for _all_ pointer types?
> >
> > IOW, a patch more like the appended.
>
> Agreed.

I thought of doing that too, but then all the various %pX formats would all
have to print the same for NULL pointers.  For instance a resource prints
out like "[0x1000-0x100f]", so I chose "[NULL]" for printing a null
resource pointer.  Maybe "[]" or "[-]" would be better?  A null MAC address
could be ":::::" or "x:x:x:x:x:x".  "N.U.L.L" or "x.x.x.x" for a null IP4
address.  And so on.  So the printout looks nicer when a NULL pointer isn't
a bug.
