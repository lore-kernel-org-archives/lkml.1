Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbXJPObr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbXJPObr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933277AbXJPObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:31:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33990 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932401AbXJPObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:31:34 -0400
X-Sasl-enc: 4yFwX8AC2azbtcz4d9BlQapAbmA6yj8Rdrp55hquj2fX 1192545089
Date: Tue, 16 Oct 2007 12:31:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016143124.GB3237@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016142121.GA21431@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Matthew Garrett wrote:
> On Tue, Oct 16, 2007 at 12:11:53PM -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > > are sent via the keyboard controller, such as the wireless and touchpad 
> > > disable keys on my HP. There are Dells that do the same for brightness 
> > 
> > It is not clear to me if they are notifications or not.  Does the firmware
> > act on the keys by itself? If it does, then they are notifications.  If it
> > does not, then they are regular hot keys and there is no controversy whether
> > they belong on the input layer or not (they do).
> 
> Yes, the firmware acts upon it.

So, I'd have to say it doesn't belong on the input layer AFAIK.

As I said, I am not against using the input layer for this, but currently
AFAIK it is not to be used for it.

> > 2. I am against sending notification events through input **that look
> > exactly the same as regular events**.  That is not a wise design choice IMO,
> > it is a very dirty hack.
> 
> Userspace is going to have to deal with this case anyway. Some vendors 
> simply don't let us distinguish.

But many do, and the less mud in the water, the better.

> > 3. We have a backlight class, a LED class, a rf-kill class and ALSA mixers.
> > Is there a real reason to pester Dmitry about the issue, if we can use these
> > alternate paths (that are indeed more generic and more suited for the job)?
> 
> It's not always going to be possible to tie notifications into a class 
> device - in the Dell case, for instance, interacting with the backlight 
> requires you to use a 200Kb library so has to be done in userspace.

Perhaps.  But for that Dell case, there is already a proper notification
system in place as well: ACPI backlight events.  You might have to get
userspace to tell the ACPI video driver that it will handle the events
(something X.org already needs, anyway), but that's about it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
