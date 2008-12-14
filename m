Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYLNJfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYLNJfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 04:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYLNJfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 04:35:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36326 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYLNJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 04:35:04 -0500
Date: Sun, 14 Dec 2008 10:28:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/3] PCI: Rework default handling of suspend
	and resume
Message-ID: <20081214092827.GA1445@ucw.cz>
References: <Pine.LNX.4.44L0.0812061324260.13426-100000@netrider.rowland.org> <alpine.LFD.2.00.0812062157590.3425@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812062201230.3425@nehalem.linux-foundation.org> <200812071439.27712.rjw@sisk.pl> <alpine.LFD.2.00.0812070824260.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812070824260.3425@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-12-07 08:34:43, Linus Torvalds wrote:
> On Sun, 7 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > So, can we just say that PCI drivers shouldn't free IRQs during suspend and
> > request them during resume, and if there's any problem that leads to, then it
> > should be solved differently?
> 
> Well, there are reasons why _individual_ drivers might want to free and 
> re-request irq's during suspend, so I wouldn't say it's wrong either.

Another (not too good) reason why you may want to unregister the
interrupt is similarity between suspend and rmmod (and resume and
insmod).

In some cases you can get away with sharing code between those two
paths...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
