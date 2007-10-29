Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbXKAOdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbXKAOdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbXKAOdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:33:02 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4266 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754580AbXKAOdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:33:00 -0400
Date: Mon, 29 Oct 2007 19:24:15 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCMCIA: prevent auto insert during resume.
Message-ID: <20071029192414.GC7742@ucw.cz>
References: <20071026105125.GA28769@enneenne.com> <20071026151141.GA4321@flint.arm.linux.org.uk> <20071026154705.GY19019@enneenne.com> <20071026160206.GC4321@flint.arm.linux.org.uk> <20071026162705.GZ19019@enneenne.com> <20071026163651.GD4321@flint.arm.linux.org.uk> <20071026165400.GA19019@enneenne.com> <20071026170030.GE4321@flint.arm.linux.org.uk> <20071026171857.GC19019@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026171857.GC19019@enneenne.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-10-26 19:18:57, Rodolfo Giometti wrote:
> On Fri, Oct 26, 2007 at 06:00:31PM +0100, Russell King wrote:
> 
> > > > > Also if you didn't eject the socket, at resume the device will be
> > > > > powered up again, my patch just prevents that a pre-powered off device
> > > > > to be turned on at resume time.
> > > > > 
> > > > > However you should consider that some embedded systems have fixed
> > > > > PCMCIA devices that can't be removed so there are no reasons to detect
> > > > > them after resume, nobody can change them. :)
> > > > > 
> > > > > Also battery powered devices can go very frequently to sleep and the
> > > > > current behavior force the user to switch off the unused device each
> > > > > time the system resumes from sleep.
> > > > 
> > > > I realise that.  I do work on embedded devices, and this behaviour is
> > > > explicitly there to support embedded devices.
> > > > 
> > > > I've suggested a workable solution to you which allows both of us to
> > > > have the behaviour we both desire from the system.  That sounds like
> > > > a negotiated solution to me...
> > > 
> > > Do you mean to switch off the socket from userland? It could be a
> > > solution but in this case the device is powered on each time even if
> > > for a short delay...
> > 
> > If it's a permanent device, and you've powered it down via pccardctl,
> > then you've powered it down from userland.  So record that it's been
> > powered down from userland.  Then, on resume, if it's been powered down
> > from userland, don't try to re-power it on resume.
> 
> But the userland doesn't re-power it on resume... it's the kernel
> itself whos re-powers the device on resume. So the userland can only
> power down the device again.

I think Russell means: at a flag into kernel. If user powers down the
device, set the flag. If flag is set during resume, avoid powering up
the device.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
