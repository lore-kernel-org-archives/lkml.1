Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYIFVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYIFVkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIFVkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:40:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58557 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYIFVkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:40:07 -0400
Date: Sat, 6 Sep 2008 22:40:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Cristi Magherusan <cristi.magherusan@net.utcluj.ro>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Power management stuff
Message-ID: <20080906214000.GA28166@srcf.ucam.org>
References: <1220732386.18701.68.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220732386.18701.68.camel@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 11:19:46PM +0300, Cristi Magherusan wrote:

> 1) How could we get the current frequency/voltage settings for the CPU,
> fr example when using SpeedStep by using the /proc filesystem?

The current frequency can be read from either /proc/cpuinfo or 
/sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq . The voltage 
isn't exposed.

> 2) It would be nice to modify a bit the CPU throttling API to be able to
> set a max value when using dynamic governors, like ondemand. 
> The frequency/voltage pair should be set to the minimum allowed by
> construction, just like it was before, and scale up to a max value set
> by the user. This would allow the user set the best balance between
> responsiveness and power consumption that suits its needs.

/sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq - though on x86, 
setting this to anything other than the maximum will result in more 
power consumption, not less.

> Also, targeting a certain temperature would be a great feature to have.

I've done some patches for this, but they're not currently merged.

> 3) Is there any plan to improve the current battery framework and
> provide information about the estimated recharging time, as it was
> before. I guess the versions before 2.6.24 used to provide this but the
> newer versions don't do it anymore.

No, you can do that in userspace. Charge time has only been exposed for 
apm, and that's because the BIOS gave it to us. Accurate figures are 
going to require learning the behaviour of the specific battery, and 
there's no way to do that sensibly in kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
