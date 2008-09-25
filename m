Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYIYT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYIYT0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYIYT0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:26:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:55761 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197AbYIYT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:26:11 -0400
Date: Thu, 25 Sep 2008 22:22:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <200809251156.10648.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net> <200809250401.54818.elendil@planet.nl> <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz> <200809251156.10648.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Jesse Barnes wrote:

> > Yes, I think that xorg/xorg i915 driver/libdrm/GEM/whatever are the 
> > biggest suspect currently, according to the data that has been 
> > gathered so far.
> We have confirmation that this isn't GEM related; according to the 
> Novell bug at https://bugzilla.novell.com/show_bug.cgi?id=425480 people 
> have hit the problem with kernels w/o GEM.

But the xorg intel driver shipped with xorg 7.4 already has support for 
GEM, right? So there could still be some bug in the GEM-aware driver 
running on non-GEM kernel, can't it?

> That doesn't rule out i915 (though I don't think any changes have gone 
> in since 2.6.26 that would have caused this) or xf86-video-intel.  It's 
> possible that X is getting confused about BAR mappings somehow, 
> resulting in a clobbered e1000e NVRAM, but why would the kernel version 
> matter in that case?  The only thing that comes to mind would be PAT...

Yes, booting with 'nopat' is on my list to try immediately after we are 
able to recover the corrupted EEPROM.

> Recent versions of the X drivers (using recent libpciaccess code) will 
> try to map the resourceN_wc file in sysfs.  It's possible that the map 
> size we end up using is wrong, leading to the situation Dave described 
> earlier where we map too much MMIO space.

This we could catch easily even with strace, right?

-- 
Jiri Kosina
SUSE Labs
