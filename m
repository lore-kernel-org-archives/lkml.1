Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbYKMH0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbYKMH0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYKMH0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:26:38 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42872 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751855AbYKMH0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:26:37 -0500
Date: Thu, 13 Nov 2008 08:26:23 +0100
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081113072623.GA1574@ucw.cz>
References: <20081105073306.GA3132@x61> <20081106082314.GA18430@x61> <20081106142107.GC23278@khazad-dum.debian.net> <200811082345.37061.rjw@sisk.pl> <20081109113011.GB8329@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109113011.GB8329@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-09 09:30:11, Henrique de Moraes Holschuh wrote:
> On Sat, 08 Nov 2008, Rafael J. Wysocki wrote:
> > > Meanwhile, I suggest you just remove the calls to fan_suspend and fan_resume
> > > as a workaround.
> > 
> > Speaking of which, last time I looked at fan_suspend and fan_resume, they
> > were hopelessly broken (I admit that was quite some time ago, though).
> 
> And they still were. I have the patch fixing it, and it reworked that path
> entirely.  Will send it soon.
> 
> > IMO, fan_suspend() is not necessary at all and the only thing fan_resume()
> > could do is to make the kernel's data structures reflect the actual state of
> > the fan.
> 
> There are NO kernel data structures to reflect the actual state of the fan.
> The fan BELONGS to the EC in the thinkpad.  We don't store any crap about it
> in the driver, except to -track- one quirk.  We query the EC for all the
> required data (which happens to be a single byte) every time we need the
> info.  If the user asks us to do something, we send that to the EC and then
> promptly forget about it.
> 
> So, I don't have to restore anything for things to just work.  The "feature"
> was added because people who set the fan to something different than AUTO
> wanted it to retain the state they set across sleep, which the box won't do
> by itself (the DSDT resets the fan on the WAK path).
> 
> OTOH, if I want to restore anything across sleep/resume, I have to store the
> state on sleep.
> 
> But there is no way I am slowing down the fan on resume: it could be in
> emergency mode due to thermal conditions.

Well... one part  of me says that if user explicitely asked for
overheat he should get that :-). 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
