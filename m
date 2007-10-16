Return-Path: <linux-kernel-owner+w=401wt.eu-S935512AbXJPUUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935512AbXJPUUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbXJPUTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:19:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:41546 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXJPUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YcxixEY88VWReMmVI4B8ToMN4E+ueujzz+8Ure4ADBTPjDUyiP1hcmdfSFznW4Ldm4DDQPZojdcpJrrD2dA+Y0Nxwds7VntfCXnAiI3M4QwXixFY8L8bePZ14XsxGExTZXqJwIq0UnQ5/TFzHX3ISR2EHOSniEWJUVWnMGxUR7g=
Message-ID: <d120d5000710161319w7b98bcc0i7e60b58e16d2c86d@mail.gmail.com>
Date: Tue, 16 Oct 2007 16:19:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jeremy Katz" <katzj@redhat.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, davej@redhat.com
In-Reply-To: <1192565511.22919.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071016141153.GA3237@khazad-dum.debian.net>
	 <20071016142121.GA21431@srcf.ucam.org>
	 <20071016143124.GB3237@khazad-dum.debian.net>
	 <20071016144016.GA21749@srcf.ucam.org>
	 <20071016165623.GA13643@khazad-dum.debian.net>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <1192565511.22919.1.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Jeremy Katz <katzj@redhat.com> wrote:
> On Tue, 2007-10-16 at 16:12 -0400, Dmitry Torokhov wrote:
> > On 10/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > > > >
> > > > > It still doesn't mean it belongs inside the stream of data for the keyboard,
> > > > > maskerading as a key press.
> > > >
> > > > But it *is* a key press!
> > >
> > > To get somewhat back on track: volume and brightness (and similar - lid
> > > close etc) events clearly are keypresses.
> > >
> > > However, I would also argue that a keypress that is acted on by the
> > > firmware automatically is *different* from a keypress that hasn't been
> > > acted on: one is a "key was pressed *and* hardware did something
> > > automatically", and the other is just a "key was pressed" event.
> > >
> > > IOW, I think the thinkpad issue (and others like it) should be fixed by
> > > splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and
> > > KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the
> > > kernel itself, for that matter) can know whether it's a informational
> > > message or whether it should be acted upon.
> >
> > I agree that these are 2 different events. My argument is that
> > "VOLUME_UP_NOTIFY" event is similar to "BATTERY_OUT_NOTIFY",
> > "DOCK_UNDOCK_NOTIFY", etc, etc and should be sent not through input
> > layer but through a generic (yet to be designed) notification
> > mechanism. Something lighter than input. Something like uevents over
> > netlink.
>
> Except that I'm _always_ going to have to be able to take these events
> as input events (because of the hardware that sends them that way), so
> why not just have everything be an input event?

Not all hardware, just some.

>
> The alternative is building up something new from the ground-up and then
> having to do translation from input to the new event type (either in the
> kernel or in userspace) which ends up meaning more work for little, if
> any, gain
>

No, I dont think you need to translate. You ahev 2 types of events -
ones require you to take action, others don't. Ones requests (reqular
keypresses), others just notifications.

Right now we have instance where sending events through input device
is simp-ly convenient because driver already has it. But in other
scenarios, when there is no input device in sight, input layer is not
the best transport. Input devices are quite havy (several kilobytes)
you may not want to add them everywhere.

-- 
Dmitry
