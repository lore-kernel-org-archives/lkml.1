Return-Path: <linux-kernel-owner+w=401wt.eu-S2993052AbXDYUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993052AbXDYUKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993050AbXDYUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:10:06 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:4281 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993052AbXDYUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:10:03 -0400
Date: Wed, 25 Apr 2007 22:09:56 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [linux-pm] Linux 2.6.21-rc6
Message-ID: <20070425200956.GA10758@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	David Brownell <david-b@pacbell.net>,
	linux-pm@lists.linux-foundation.org, pavel@suse.cz,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, linux-pm@lists.osdl.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704152154.09212.rjw@sisk.pl> <20070425171409.GA9990@melchior.yamamaya.is-a-geek.org> <200704252136.58470.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704252136.58470.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 25 April 2007 19:14, Tobias Diedrich wrote:
> > Rafael J. Wysocki wrote:
> > > On Sunday, 15 April 2007 21:40, Tobias Diedrich wrote:
> > > > Rafael J. Wysocki wrote:
> > > > > On Sunday, 15 April 2007 17:14, David Brownell wrote:
> > > > > > On Sunday 15 April 2007 4:16 am, Rafael J. Wysocki wrote:
> > > > > > > On Sunday, 15 April 2007 10:02, Tobias Diedrich wrote:
> > > > > > > I think using the 'shutdown' mode of suspend would be better.  There's a little
> > > > > > > point in using 'platform' on desktop systems anyway.
> > > > > > > 
> > > > > > > Frankly, I don't know what to do about it.  If we move platform_finish() after
> > > > > > > device_resume(), some systems may be broken ...
> > > > > > 
> > > > > > What I'm curious about is exactly why the patch matters.  What ACPI
> > > > > > magic is being invoked to confuse, or unconfuse, those controllers?
> > > > > 
> > > > > I think the patch helps, because it makes the ACPI magic be done while the
> > > > > i8042's .resume() is being executed.
> > > > > 
> > > > > Which makes me think the following patch might help:
> > > > 
> > > > Unfortunately not, I tried this before disabling CONFIG_SERIO_I8042.
> > > 
> > > Well, this means i8042 can be ruled out, so the problem probably is related
> > > to the ACPI resume which makes it _much_ more difficult to debug.
> > > 
> > > Can you compile the ACPI drivers: processor, thermal, fan, battery, etc. as
> > > modules, boot the kernel with init=/bin/bash and see if the problem is still
> > > present (please keep CONFIG_SERIO_I8042 unset just in case)?
> > > 
> > > Rafael
> > 
> > I first tried it with acpi+cpufreq completely disabled (works).
> > Then I tried it with acpi enabled, but everything as modules and
> > those not loaded (init=/bin/bash, hangs at second suspend).
> 
> Have you tried with ACPI and without cpufreq?

Yes, the second one was with ACPI enabled and cpufreq disabled
(CONFIG_X86_ACPI_CPUFREQ is not set).

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
