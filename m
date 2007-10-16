Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXJPQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXJPQ4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXJPQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:56:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38505 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbXJPQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:56:31 -0400
X-Sasl-enc: qZDTWNvrLQTN9YOkKm/M0Xl2yn5oucHbV+OjaSVl+GBS 1192553789
Date: Tue, 16 Oct 2007 14:56:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016165623.GA13643@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016144016.GA21749@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Matthew Garrett wrote:
> On Tue, Oct 16, 2007 at 12:31:24PM -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > > Yes, the firmware acts upon it.
> > 
> > So, I'd have to say it doesn't belong on the input layer AFAIK.

> They're keys that generate scancodes through the keyboard controller. 

The fact is that we were not used to anything using the keyboard controller
as a message-passing device, but nowadays that is (unfortunately) happening.

It still doesn't mean it belongs inside the stream of data for the keyboard,
maskerading as a key press.

> Not having them go through the input layer requires actively forcing 
> them into some other route, which seems excessive.

I don't think it is excessive at all, actually.  But I am known to take the
longer and harder road if I think the end result will be neater and more
organized.

> > > Userspace is going to have to deal with this case anyway. Some vendors 
> > > simply don't let us distinguish.
> > 
> > But many do, and the less mud in the water, the better.
> 
> There's no advantage in having to implement multiple solutions. If we're 
> stuck with one of them, we might as well just use it for the other cases 
> as well.

IMO we might as well go to the clean road, deploy a generic interface that
CAN do it properly (might as well be input, but Dmitry has some good reasons
not to want it there), and move to it.

> > > It's not always going to be possible to tie notifications into a class 
> > > device - in the Dell case, for instance, interacting with the backlight 
> > > requires you to use a 200Kb library so has to be done in userspace.
> > 
> > Perhaps.  But for that Dell case, there is already a proper notification
> > system in place as well: ACPI backlight events.  You might have to get
> > userspace to tell the ACPI video driver that it will handle the events
> > (something X.org already needs, anyway), but that's about it.
> 
> No, these aren't ACPI keys and the machines don't provide backlight 
> control through ACPI. It's not a problem with more recent Dells, but 
> machines before mid-2006 or so have this issue.

Am I the only one seeing the irony on that comment over the idea of sending
such events through the input layer?  ACPI is not just a way to talk to AML
crap in the BIOS.  Is a (somewhat obtuse, very limited) generic interface to
model the hardware.  But for backlight, it certianly is powerful enough.

If you want an even more generic interface, I am fine with it too (just make
sure to move ACPI over to that interface as well).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
