Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbZLMBl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbZLMBl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbZLMBly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:41:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36627 "HELO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933622AbZLMBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:41:52 -0500
Date: Sat, 12 Dec 2009 20:27:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ferenc Wagner <wferi@niif.hu>, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: s2disk encryption was Re: [linux-pm] intermittent suspend problem
	again
Message-ID: <20091212192712.GB1308@ucw.cz>
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200912011328.15551.rjw@sisk.pl> <877ht68u4h.fsf@tac.ki.iif.hu> <200912012232.50951.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912012232.50951.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> On the other hand, I reverted 8fbd962e3, recompiled and replaced the
> > >> module, and got the freeze during hibernation.  And that was the bulk of
> > >> the changes since 2.6.31...  I'll revert the rest and test again, but
> > >> that seems purely cosmetic, so no high hopes.
> > >> 
> > >>> In addition to that, you can run multiple hibernation/resume cycles in
> > >>> a tight loop using the RTC wakealarm.
> > >> 
> > >> I'll do so, as soon as I find a way to automatically supply the dm-crypt
> > >> passphrase... or even better, learn to hibernate to ramdisk from the
> > >> initramfs. :)
> > >
> > > Well, you don't need to use swap encryption for _testing_. :-)
> > 
> > I use partition encryption, everything except for /boot is encrypted.
> 
> If /boot is big enough, you could use a swap file in /boot for the testing.
> 
> > Apropos: does s2disk perform encryption with a temporary key even if I
> > don't supply and RSA key, to protect mlocked application data from being
> > present in the swap after restore?
> 
> It can do that, but you need to provide a key during suspend and resume.
> 
> Otherwise it doesn't use a random key, because it would have to store it in
> the clear in the image header.

I believe it can use random key, stored in clear in image
header. Reason is... image header is easier to overwrite than removing
whole image.

That was original motivation for encryption... not having to overwrite
swap data with zeros.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
