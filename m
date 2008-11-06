Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYKFPXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYKFPXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYKFPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:23:00 -0500
Received: from eazy.amigager.de ([213.239.192.238]:58698 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYKFPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:23:00 -0500
Date: Thu, 6 Nov 2008 16:22:55 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106152255.GA23717@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61> <20081106141121.GB23278@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141121.GB23278@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 12:11:21 -0200, Henrique de Moraes Holschuh wrote:

[...]

> fulll-speed > 7 > AUTO.
> 
> > Correction: I just tested a bit further, and it doesn't work. If I set
> > fan level to 3, suspend, resume, set fan level to auto, and
> > resume/suspend again, fan level is restored to 3. This is because
> > fan_control_desired_level isn't updated by fan_update_desired_level()
> 
> Fan level should NEVER be restored to 3, it should end up set to auto,
> full-speed, or 7 when the box finishes resuming.  If it can be restored to
> 3, something is hideously broken.

Then it seems I misunderstood the whole fan state resume stuff. I
thought that it restores the value that was set before suspend, unless
it was set to some emergency value meanwhile. I think I should not look
into this further, as there are too many restrictions and/or side
effects involved. However, I think it's a good idea to document all
that in the source code in the future, so that other people can really
understand this. I think it's also a good idea to collect all the
quirks, safety nets and fallbacks in a central place, so that the
context is clear.


> Maybe something in the hwmon class is also trying to keep values across
> sleep/suspend?

This happened only with my first (broken) patch, so no need to bother
about this.

Regards,
Tino
