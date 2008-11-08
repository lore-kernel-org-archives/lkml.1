Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYKHWlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYKHWlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYKHWlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:41:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41487 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbYKHWlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:41:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Date: Sat, 8 Nov 2008 23:45:36 +0100
User-Agent: KMail/1.9.9
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081106082314.GA18430@x61> <20081106142107.GC23278@khazad-dum.debian.net>
In-Reply-To: <20081106142107.GC23278@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811082345.37061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 6 of November 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 06 Nov 2008, Tino Keitel wrote:
> > The whole fan level stuff looks a bit complicated to me. Especially the
> 
> It is.  The sysfs hwmon interface does not map 1:1 with the three possible
> thinkpad fan control interfaces.  fan_control_desired_level is used for that
> interface mainly, since I have to remember the last state used that was in
> the set of 0-7, ignoring AUTO (which is a separate pwm control mode for
> hwmon) and full-speed (which is a separate pwm control mode for hwmon).
> 
> It is hijacked by fan_suspend/fan_resume to store state between
> sleep/resume, because that was convenient.  Too bad I failed to notice it
> would not work properly for that.
> 
> > The attached patch tries to simplify this a bit. It sets
> 
> NAK, it would break a lot of stuff.   See my previous reply on this thread
> for *some* of the stuff it would break.
> 
> I will have a proper patch out probably within 24h but most certainly before
> next Monday.
> 
> Meanwhile, I suggest you just remove the calls to fan_suspend and fan_resume
> as a workaround.

Speaking of which, last time I looked at fan_suspend and fan_resume, they
were hopelessly broken (I admit that was quite some time ago, though).

IMO, fan_suspend() is not necessary at all and the only thing fan_resume()
could do is to make the kernel's data structures reflect the actual state of
the fan.

Thanks,
Rafael
