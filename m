Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXCDTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXCDTCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 14:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXCDTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 14:02:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33202 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXCDTCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 14:02:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: Suspend/resume semantics for ISDN drivers (was: NAK new drivers without proper power management?)
Date: Sun, 4 Mar 2007 20:04:25 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, nigel@nigel.suspend2.net,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <45CFB06B.5080102@imap.cc> <45E9FB54.4030905@imap.cc>
In-Reply-To: <45E9FB54.4030905@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703042004.26684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 3 March 2007 23:48, Tilman Schmidt wrote:
> Ok, I've thought some more but I still don't know ...
> 
> On 12.02.2007 01:10 I wrote:
> > I don't doubt your basic assessment. However it doesn't translate that
> > easily into a real implementation. In my case, I maintain a USB driver,
> > so I have to deal with USB specifics of suspend/resume which happen not
> > to be that well documented. My driver provides an isdn4linux device but
> > isdn4linux knows nothing about suspend/resume so I am on my own on how
> > to reconcile the two. The device itself, though in turn far from trivial,
> > is actually the least of my worries.
> 
> So, how *should* an isdn4linux driver handle a request to suspend?
> Specifically, if there are active connections, should it try to
> shut them down in an orderly fashion (which might imply some delays
> waiting for the remote station to acknowledge, etc.)? Should it kill
> them abruptly (as for a USB unplug event)? Or should it just refuse
> to suspend while a connection is still active?

I think that refusing to suspend wouldn't be a good approach (think of an
emergency suspend when the battery is running low).

Probably the closing of connections would be the nicest thing from the
user's point of view.

Greetings,
Rafael
