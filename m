Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXLKNrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXLKNrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKNqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:46:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46980 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbXLKNqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:46:54 -0500
Date: Tue, 11 Dec 2007 14:47:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <david@davidnewall.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071211134725.GB17992@elf.ucw.cz>
References: <20071209125458.GB4381@ucw.cz> <20071209165908.GA15910@one.firstfloor.org> <20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211131413.1079be59@the-village.bc.nu> <20071211133249.GA16750@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211133249.GA16750@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-12-11 14:32:49, Andi Kleen wrote:
> > The LPC bus behaviour is absolutely and precisely defined. The timing of
> > the inb is defined in bus clocks which is perfect as the devices needing
> > delay are running at a fraction of busclock usually busclock/2.
> > 
> > Older processors did not have a high precision timer so you couldn't
> > calibrate loop based delays for 1uS.
> 
> For newer CPUs udelay() would be probably fine though. We seem
> to have several documented examples now where the bus aborts
> trigger hardware bugs, and it is always better to avoid such situations.
> 
> I still think the best strategy would be to switch based on TSC
> availability. Perhaps move out*_p out of line to avoid code bloat.

Why is TSC significant? udelay() based on bogomips seems to be good
enough...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
