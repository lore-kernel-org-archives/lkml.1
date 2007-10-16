Return-Path: <linux-kernel-owner+w=401wt.eu-S966283AbXJPVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966283AbXJPVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965741AbXJPVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:44:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965970AbXJPVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:44:35 -0400
Date: Tue, 16 Oct 2007 13:32:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
In-Reply-To: <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> 
 <20071015210737.GA15293@khazad-dum.debian.net>  <20071016130053.GA20010@srcf.ucam.org>
  <20071016141153.GA3237@khazad-dum.debian.net>  <20071016142121.GA21431@srcf.ucam.org>
  <20071016143124.GB3237@khazad-dum.debian.net>  <20071016144016.GA21749@srcf.ucam.org>
  <20071016165623.GA13643@khazad-dum.debian.net>  <20071016184606.GB25181@srcf.ucam.org>
  <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, Dmitry Torokhov wrote:
> 
> I agree that these are 2 different events. My argument is that
> "VOLUME_UP_NOTIFY" event is similar to "BATTERY_OUT_NOTIFY",
> "DOCK_UNDOCK_NOTIFY", etc, etc and should be sent not through input
> layer but through a generic (yet to be designed) notification
> mechanism. Something lighter than input. Something like uevents over
> netlink.

Well, I'd argue that:

 - it's going to be the same entity that cares in both cases (ie anybody 
   who is ready to accept VOLUME_UP keypresses is also the exact same 
   party that also wants to know if VOLUME_UP happened *independently*)

   Ergo: making it a separate "generic" notification is actually totally 
   counterproductive, because it just adds complexity.

 - it really is a keypress. Yes, it's a keypress with side effects, but 
   it still tends to have a distinct source, and as such it is interesting 
   *as* a keypress. 

   IOW: it should have all the same "incidental" side effects as any other 
   keypress. Example: I think it's reasonable to consider it an event as 
   far as the screen saver is concerned. In other words, it's not *just* a 
   "volume was raised" event. It's a "volume was raised, and the user 
   actually pressed a key to do so".

So I do think they are keypresses, although I also suspect that like many 
other magical keys, the "NOTIFY" version is often also totally hidden by 
hardware/firmware interactions (ie I'm pretty sure that many of those 
special keys will never be visible at all to the OS, because the firmware 
hides the fact that they were pressed entirely!)

		Linus
