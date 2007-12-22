Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbXLVGTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbXLVGTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXLVGTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:19:22 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:49086 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750870AbXLVGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:19:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=FpoJmZswXm2HfIAOWlp+nSjbR1z5KlCwqlW5vKQPTOntXUStrFA77R2zPvZNTUQlNFaA0Z5uf1h0I3zJ3QdfxrmpQMLza5vd8qAwHjS6JJ5QG4fjlNtA9WCF86tmf8Zf3X0WQXFo+CD+pDX6H+N5+lLOB6BxEQOtFlsYzrVlxtA=  ;
X-YMail-OSG: bVUR3SEVM1nOIpmRHB1d9E2reeenFffDPQ0QthhTFbadZ1lswL5GNYVWc4jcJ_ZZr2ug7_vK_A--
Date: Fri, 21 Dec 2007 22:19:19 -0800
From: David Brownell <david-b@pacbell.net>
To: jengelh@computergmbh.de, a1426z@gawab.com
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com>
 <Pine.LNX.4.64.0712212211420.11671@fbirervta.pbzchgretzou.qr>
 <20071221235854.DF7931915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200712220806.24730.a1426z@gawab.com>
In-Reply-To: <200712220806.24730.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20071222061919.A5B1D1915EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Notice that this whole menu is for "Host-side USB", except for that
> > gadget stuff.  That might usefully be labeled as "Peripheral-side USB".
> >
> > For that matter, it could be moved up a level in the menu, so the top
> > level driver menu has two USB entries:  Host side, and Peripheral side.
>
> Actually, when you disable Host-side USB support, the menu looks like this:
>
> ┌───────────???──────────────────???──────────────────???───────────────┐
> │ --- USB support                                                 │
> │ < >   Support for Host-side USB  --->                           │
> │       USB Gadget Support  --->                                  │
> │                                                                 │

Right, that's what I said.   It makes the gadget stuff needlessly hard
to find, as well as being less clear about what a "gadget" is than it
really should be.


> I think renaming 'USB Gadget Support' to 'Support for Peripheral-side USB' is 
> probably a good idea.

Only for displaying in its topmost menu...


> > The driver stacks are independent of each other, except for common data
> > structures like what's in the <linux/usb/ch9.h> header file.  I think
> > there's no real point, other than history, to having both sides share
> > the same menu.
>
> They aren't.

How can you say that, when you showed (right above!!) that they are???
Sure, there are submenus too.  But they're clearly in the same menu.


>	USB Gadget Support is in its own sub-menu.  And strictly 
> speaking, Host-side USB should be too, but some people may feel that this 
> would be nesting it too deep, and so it unfolds in the same menu.

Which is why my suggestion was to have them both move up a level, with
host and peripheral side menus nested normally:

	Device Drivers:
		...
		[ ] HID devices
		< > Host side USB
		< > Peripheral side USB
		< > MMC/SD/SDIO card support
		[ ] LED support
		...

That way both host and peripheral side support would have their own
menu, and that pointless nesting would be reduced.

- Dave

