Return-Path: <linux-kernel-owner+w=401wt.eu-S935592AbXJPUPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935592AbXJPUPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXJPUPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:15:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXJPUPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:15:06 -0400
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
From: Jeremy Katz <katzj@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, davej@redhat.com
In-Reply-To: <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071015210737.GA15293@khazad-dum.debian.net>
	 <20071016130053.GA20010@srcf.ucam.org>
	 <20071016141153.GA3237@khazad-dum.debian.net>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 16:11:51 -0400
Message-Id: <1192565511.22919.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 16:12 -0400, Dmitry Torokhov wrote:
> On 10/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > > >
> > > > It still doesn't mean it belongs inside the stream of data for the keyboard,
> > > > maskerading as a key press.
> > >
> > > But it *is* a key press!
> >
> > To get somewhat back on track: volume and brightness (and similar - lid
> > close etc) events clearly are keypresses.
> >
> > However, I would also argue that a keypress that is acted on by the
> > firmware automatically is *different* from a keypress that hasn't been
> > acted on: one is a "key was pressed *and* hardware did something
> > automatically", and the other is just a "key was pressed" event.
> >
> > IOW, I think the thinkpad issue (and others like it) should be fixed by
> > splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and
> > KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the
> > kernel itself, for that matter) can know whether it's a informational
> > message or whether it should be acted upon.
> 
> I agree that these are 2 different events. My argument is that
> "VOLUME_UP_NOTIFY" event is similar to "BATTERY_OUT_NOTIFY",
> "DOCK_UNDOCK_NOTIFY", etc, etc and should be sent not through input
> layer but through a generic (yet to be designed) notification
> mechanism. Something lighter than input. Something like uevents over
> netlink.

Except that I'm _always_ going to have to be able to take these events
as input events (because of the hardware that sends them that way), so
why not just have everything be an input event?

The alternative is building up something new from the ground-up and then
having to do translation from input to the new event type (either in the
kernel or in userspace) which ends up meaning more work for little, if
any, gain

Jeremy

