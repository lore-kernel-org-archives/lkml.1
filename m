Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYCYOnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYCYOnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYCYOmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:42:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3837 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754610AbYCYOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:42:50 -0400
Date: Tue, 25 Mar 2008 09:46:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: APM crashes when IO is going on
Message-ID: <20080325084619.GA4547@ucw.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <200803201131.25828.rjw@sisk.pl> <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz> <200803210127.56437.rjw@sisk.pl> <Pine.LNX.4.64.0803212055550.6726@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803212055550.6726@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'm now running on -rc6, so I'll see (it takes some days for the bug to 
> > > appear). Where is that patch that went to -rc4 and that may fix it?
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7a8d37a37380e2b1500592d40b7ec384dbebe7a0
> 
> I found another problem --- present in 2.6.23.1, 2.6.25rc3, 2.6.25rc6
> 
> --- when I run three threads concurrently reading raw disk partition and 
> suspend, I get 100% reproducible failure. (with one thread running it 
> usually succeeds, sometimes fail)
> 
> Either the on-going I/O will jam BIOS and I need to remove power to 
> continue.
> 
> Or the machine suspends, wakes up and reports "hda: lost interrupt" 
> (2.6.23.1 was able to recover from this condition, 2.6.25rc3,6 does not 
> recover and it is not able to send any more disk IOs).

Kernel should recover from lost interrupt. Can you track down this
regression?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
