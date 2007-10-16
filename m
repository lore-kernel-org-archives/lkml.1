Return-Path: <linux-kernel-owner+w=401wt.eu-S933594AbXJPOVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbXJPOVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXJPOVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:21:35 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:51715 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbXJPOVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:21:34 -0400
Date: Tue, 16 Oct 2007 15:21:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <20071016142121.GA21431@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016141153.GA3237@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:11:53PM -0200, Henrique de Moraes Holschuh wrote:
> On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > are sent via the keyboard controller, such as the wireless and touchpad 
> > disable keys on my HP. There are Dells that do the same for brightness 
> 
> It is not clear to me if they are notifications or not.  Does the firmware
> act on the keys by itself? If it does, then they are notifications.  If it
> does not, then they are regular hot keys and there is no controversy whether
> they belong on the input layer or not (they do).

Yes, the firmware acts upon it.

> 2. I am against sending notification events through input **that look
> exactly the same as regular events**.  That is not a wise design choice IMO,
> it is a very dirty hack.

Userspace is going to have to deal with this case anyway. Some vendors 
simply don't let us distinguish.

> 3. We have a backlight class, a LED class, a rf-kill class and ALSA mixers.
> Is there a real reason to pester Dmitry about the issue, if we can use these
> alternate paths (that are indeed more generic and more suited for the job)?

It's not always going to be possible to tie notifications into a class 
device - in the Dell case, for instance, interacting with the backlight 
requires you to use a 200Kb library so has to be done in userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
