Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYEWIn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYEWIn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYEWInt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:43:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57917 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbYEWInr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:43:47 -0400
Date: Fri, 23 May 2008 03:43:46 -0500
From: Robin Holt <holt@sgi.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Robin Holt <holt@sgi.com>, astarikovskiy@suse.de,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sony laptop battery has odd behavior with 2.6.26-rc3ish build.
Message-ID: <20080523084346.GG4287@sgi.com>
References: <20080521115723.GF4287@sgi.com> <20080523072156.GA8964@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523072156.GA8964@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is my battery/laptop ACPI.  I just booted back to  2.6.22-14
and the behavior remained the same.  Interestingly, it started chaged
to 4096mAh and I unplugged it.  The battery began discharging.  When it
reached 3800mAh, I plugged it back in.  The battery indicated it was
charging, but remaining capacity slowly declined to 3072mAh where it
stablized.  Removing/Instaling the battery gave no change in behavior,
upon reinsertion, the reading remained at 3072mAh.  I then unplugged the
charger.  It was approx 35 seconds before the reading began to trickle
back down.  Again, it trickled down slowly (which it is doing currently).

Either it has always behaved this way and I just didn't notice it or
something has changed inside my battery.  I have not done any BIOS update
in years (last one that was available).

Thanks,
Robin

On Fri, May 23, 2008 at 09:21:56AM +0200, Pavel Machek wrote:
> Hi!
> 
> > A couple days ago, I updated my test build to commit
> > 8033c6e9736c29cce5f0d0abbca9a44dffb20c39 and noticed an odd behavior
> > with the battery.  If I unplug the power, the battery discharges and
> > that is reflected in /proc/acpi/battery/BAT0/state.  I am not certain
> > the discharge is continuous and uniform or if it goes in steps.  When I
> > plug the power back in, the level stays at a constant value (+-1mAh)
> > for a considerable period of time.  It then does a single step back to
> > the fully charged value.
> > 
> > I have not done any searching to see when this began.  I had been running
> > the ubuntu 2.6.22-14 kernel before this and the behavior was normal.
> > 
> > I am not certain what information you will need.  Commit is above.
> 
> git bisect would certainly help...
> 
> > $ cat /proc/acpi/battery/BAT0/alarm
> > alarm:                   unsupported
> > $ cat /proc/acpi/battery/BAT0/info
> > present:                 yes
> > design capacity:         4800 mAh
> > last full capacity:      4096 mAh
> > battery technology:      non-rechargeable
> 
> Because something is clearly wrong here.
> 
> 						Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
