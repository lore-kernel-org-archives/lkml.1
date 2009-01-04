Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZADUmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZADUmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZADUl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:41:56 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:50516 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZADUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:41:55 -0500
Date: Sun, 4 Jan 2009 12:41:49 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
In-Reply-To: <1231062493.15389.105.camel@pasglop>
Message-ID: <Pine.LNX.4.58.0901041232460.25853@shell2.speakeasy.net>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org> 
 <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain> 
 <1231019614.15389.104.camel@pasglop>  <Pine.LNX.4.58.0901031827380.25853@shell2.speakeasy.net>
 <1231062493.15389.105.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Benjamin Herrenschmidt wrote:
> > I thought of doing that too, but then all the various %pX formats would all
> > have to print the same for NULL pointers.  For instance a resource prints
> > out like "[0x1000-0x100f]", so I chose "[NULL]" for printing a null
> > resource pointer.  Maybe "[]" or "[-]" would be better?  A null MAC address
> > could be ":::::" or "x:x:x:x:x:x".  "N.U.L.L" or "x.x.x.x" for a null IP4
> > address.  And so on.  So the printout looks nicer when a NULL pointer isn't
> > a bug.
>
> And how often is that ?

For resource pointers it's not uncommon.  There are many cases when it's perfectly
ok for a resource pointer to be null, e.g. res->parent is often null, pci devices
and busses don't usually have all possible ranges, etc.  It nice to get decent info
printouts without having the check for NULL pointers.
