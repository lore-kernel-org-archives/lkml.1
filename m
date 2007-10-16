Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbXJPOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbXJPOkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbXJPOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:40:29 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:54223 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbXJPOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:40:28 -0400
Date: Tue, 16 Oct 2007 15:40:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <20071016144016.GA21749@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016143124.GB3237@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:31:24PM -0200, Henrique de Moraes Holschuh wrote:
> On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > Yes, the firmware acts upon it.
> 
> So, I'd have to say it doesn't belong on the input layer AFAIK.

They're keys that generate scancodes through the keyboard controller. 
Not having them go through the input layer requires actively forcing 
them into some other route, which seems excessive.

> > Userspace is going to have to deal with this case anyway. Some vendors 
> > simply don't let us distinguish.
> 
> But many do, and the less mud in the water, the better.

There's no advantage in having to implement multiple solutions. If we're 
stuck with one of them, we might as well just use it for the other cases 
as well.

> > It's not always going to be possible to tie notifications into a class 
> > device - in the Dell case, for instance, interacting with the backlight 
> > requires you to use a 200Kb library so has to be done in userspace.
> 
> Perhaps.  But for that Dell case, there is already a proper notification
> system in place as well: ACPI backlight events.  You might have to get
> userspace to tell the ACPI video driver that it will handle the events
> (something X.org already needs, anyway), but that's about it.

No, these aren't ACPI keys and the machines don't provide backlight 
control through ACPI. It's not a problem with more recent Dells, but 
machines before mid-2006 or so have this issue.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
