Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYKJWN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYKJWN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYKJWNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:13:48 -0500
Received: from relay2-v.mail.gandi.net ([217.70.178.76]:41412 "EHLO
	relay2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKJWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:13:47 -0500
Date: Mon, 10 Nov 2008 23:13:43 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081110221343.GA17951@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	Alex Deucher <alexdeucher@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110094239.GA14204@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110094239.GA14204@atrey.karlin.mff.cuni.cz>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 10:42:39AM +0100, Pavel Machek wrote:
> Trying with minimum drivers is likely to help here, and should be
> easier than bisect. Boot with init=/bin/bash, then try "devices" >
> pm_dest and disk > state...

Some progress with (2.6.28-rc4 this time)...  I've booted with /bin/bash
as init: works.

Then I rebooted in single mode => works
Runlevel 3 => works
Runlevel 5 => doesn't work

In terms of devices, lsmod says the only differences between runlevel 3
and runlevel 5 are that both drm and radeon are loaded...

If I rmmod radeon and drm while X is running suspending the devices
works...  I guess I don't have DRI enabled???  Just looked at the logs,
I guess I don't [1]...

Looking at a git log -p of gpu/drm/radeon shows lots of difference
between 2.6.26 and HEAD...  I see a vblank change [2] that changes the
way the device is suspended, not sure if it really matters though...

Alex, Jesse and/or Dave can you think of anything before I bisect?  FYI
my radeon is a:
ATI Technologies Inc Radeon Mobility M7 LW [Radeon Mobility 7500] rev 0,

Cheers,
Mathieu

[1]
(EE) RADEON(0): Static buffer allocation failed.  Disabling DRI.
(EE) RADEON(0): At least 21263 kB of video memory needed at this resolution and depth.

[2] Commit 0a3e67a4caac273a3bfc4ced3da364830b1ab241
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
