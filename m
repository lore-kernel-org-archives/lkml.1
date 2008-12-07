Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYLGNk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYLGNk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYLGNkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:40:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33701 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYLGNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:40:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sun, 7 Dec 2008 14:39:27 +0100
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org> <alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812062201230.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812062201230.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071439.27712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Linus Torvalds wrote:
> > 
> > And btw, I'm talking suspend, not hibernate. 

Even as far as hibernation is concerned, I wouldn't _expect_ any BIOS to do
anything like this as long as we use the ACPI facility to enter S4.

> And, btw, even if anybody actually does this, it should be up to the 
> interrupt controller logic to re-initialize the interrupts so that they 
> are back where they belong. IOW, we should never show such _idiotic_ 
> brokenness to any actual driver, it should all be remapped and handled 
> below them.
> 
> And I still have never heard any valid reason to do it in the first place, 
> so until somebody actually gives a real example and an explanation, I 
> would suggest ignoring the whole issue as some insane rumblings from crazy 
> hw/firmare people doing idiotic things.

While I'd really like to do that, I also think that we should make all drivers
behave in the same way in this area.

Also, we need to state clearly what the _recommended_way of doing that is,
at least as a guidance for driver writers if not for anything else.

So, can we just say that PCI drivers shouldn't free IRQs during suspend and
request them during resume, and if there's any problem that leads to, then it
should be solved differently?

Rafael
