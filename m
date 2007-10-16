Return-Path: <linux-kernel-owner+w=401wt.eu-S935418AbXJPTPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbXJPTPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761049AbXJPTOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:14:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbXJPTOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:14:54 -0400
Date: Tue, 16 Oct 2007 12:14:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
In-Reply-To: <20071016184606.GB25181@srcf.ucam.org>
Message-ID: <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
 <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org>
 <20071016141153.GA3237@khazad-dum.debian.net> <20071016142121.GA21431@srcf.ucam.org>
 <20071016143124.GB3237@khazad-dum.debian.net> <20071016144016.GA21749@srcf.ucam.org>
 <20071016165623.GA13643@khazad-dum.debian.net>
 <20071016184606.GB25181@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, Matthew Garrett wrote:
> >
> > It still doesn't mean it belongs inside the stream of data for the keyboard,
> > maskerading as a key press.
> 
> But it *is* a key press!

To get somewhat back on track: volume and brightness (and similar - lid 
close etc) events clearly are keypresses.

However, I would also argue that a keypress that is acted on by the 
firmware automatically is *different* from a keypress that hasn't been 
acted on: one is a "key was pressed *and* hardware did something 
automatically", and the other is just a "key was pressed" event.

IOW, I think the thinkpad issue (and others like it) should be fixed by 
splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and 
KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the 
kernel itself, for that matter) can know whether it's a informational 
message or whether it should be acted upon.

Because clearly we seem to have both cases, and while I think we should 
try to move towards a "user mode does all actions" model where screen 
brightness is under the control of X, that isn't necessarily the case now, 
nor perhaps even reachable on all hw platforms.

Hmm?

		Linus
