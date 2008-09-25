Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYIYW71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYIYW71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYIYW7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:59:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54881 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYIYW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:59:17 -0400
Message-ID: <48DC176E.6020807@zytor.com>
Date: Thu, 25 Sep 2008 15:57:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       airlied@gmail.com, Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net> <200809251156.10648.jbarnes@virtuousgeek.org> <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz> <200809251236.12287.jbarnes@virtuousgeek.org> <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 25 Sep 2008, Jesse Barnes wrote:
> 
>> However, the "Factory" log at #425480 *does* indicate that a GEM aware 
>> 2D driver was loaded (the "[drm:i915_getparam] *ERROR* Unknown parameter 
>> 5" message indicates as much), but the kernel was definitely not GEM 
>> aware otherwise the call would have succeeded.  So that rules out GEM 
>> proper, but it could still be a bug in one of the non-GEM paths in the 
>> experimental xf86-video-intel bits the various distros seem to be 
>> picking up.
> 
> That was exactly the point I was trying to make, that these error paths 
> will probably also need auditing, once we rule out the possibility of 
> NVRAM being overwritten from kernelspace.
> 

Okay, I just had a scary and hopefully stupid thought.

Especially Intel often has backchannels between the chipset and the 
Ethernet controller for management functions -- anything from WoL to 
IPMI -- generally over some kind of low-speed serial bus.

We're not in a situation where the EEPROM can be touched from the 
chipset via the SMBus or some other non-CPU channel?

	-hpa
