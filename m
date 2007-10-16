Return-Path: <linux-kernel-owner+w=401wt.eu-S935070AbXJPSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbXJPSq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXJPSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:46:21 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:40886 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbXJPSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:46:21 -0400
Date: Tue, 16 Oct 2007 19:46:06 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <20071016184606.GB25181@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org> <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org> <20071016165623.GA13643@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016165623.GA13643@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:56:23PM -0200, Henrique de Moraes Holschuh wrote:
> On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > They're keys that generate scancodes through the keyboard controller. 
> 
> The fact is that we were not used to anything using the keyboard controller
> as a message-passing device, but nowadays that is (unfortunately) happening.
>
> It still doesn't mean it belongs inside the stream of data for the keyboard,
> maskerading as a key press.

But it *is* a key press!
 
> > There's no advantage in having to implement multiple solutions. If we're 
> > stuck with one of them, we might as well just use it for the other cases 
> > as well.
> 
> IMO we might as well go to the clean road, deploy a generic interface that
> CAN do it properly (might as well be input, but Dmitry has some good reasons
> not to want it there), and move to it.

I think Dmitry is wrong here. Input is the right layer for sending 
keypress information to userland.

> > No, these aren't ACPI keys and the machines don't provide backlight 
> > control through ACPI. It's not a problem with more recent Dells, but 
> > machines before mid-2006 or so have this issue.
> 
> Am I the only one seeing the irony on that comment over the idea of sending
> such events through the input layer?  ACPI is not just a way to talk to AML
> crap in the BIOS.  Is a (somewhat obtuse, very limited) generic interface to
> model the hardware.  But for backlight, it certianly is powerful enough.

Well, yes, we could have a layer in the kernel to turn the key events 
into ACPI events and then let the video module turn them back into input 
events, but that still wouldn't deal with the fact that legacy Dell 
backlight control isn't going to happen in the kernel.

Anyway. My point was that saying we shouldn't put notification events 
through the input layer is at odds with reality - we already do, and 
they already arrive with EV_KEY. Userspace copes. Who benefits from 
doing it in any other way? Userspace doesn't - we'd need to rewrite 
parts of it to deal with the new setup. The kernel doesn't, because it 
doesn't consume these events itself. Coming up with a "cleaner" 
interface just results in more work for everyone. We should just go with 
the defacto standard, especially since it's one that's been implemented 
by various hardware vendors.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
