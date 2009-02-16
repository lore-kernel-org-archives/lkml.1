Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZBPWsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZBPWsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZBPWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:47:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43736 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZBPWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:47:55 -0500
Date: Mon, 16 Feb 2009 23:47:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve Hj??nnev??g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216224741.GE1370@ucw.cz>
References: <200902160010.16955.rjw@sisk.pl> <20090215164456.34aef7e8@infradead.org> <adad4di7vef.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad4di7vef.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-02-15 22:23:04, Roland Dreier wrote:
>  > > (2) put given subset of devices into low power states whenever they
>  > > are not used, without putting the entire system into a sleep state.
> 
>  > For (2), for me the answer is very obvious:
> 
>  > The Device Driver needs to make the decision to put the device to sleep.
>  > There are no ifs and buts about this.
> 
> For PC-like systems this is probably all that needs to be said.  However
> for highly integrated SoC systems (as Android is obviously targeting)
> there is another level of complexity due to the interdependency among
> various devices... eg things like if I know the SD controller and the
> wifi chip are both asleep then I can put my SDIO controller to sleep;
> and if the SDIO controller and the NAND controller are both asleep then
> I can stop clock X and save more power; etc etc.
> 
> This is what the PowerOp/DPM work was all about.  Unfortunately that
> doesn't seem to have made much progress upstream.  But there's no doubt
> in my mind that we need some framework beyond individual drivers that
> manages the system's power as a whole.  And the current device tree is
> probably not sufficient -- eg the bus hierarchy of a device may not
> match up with the clock tree at all.

Well, that's why clock framework exists. But none  of this is visible
to userland. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
