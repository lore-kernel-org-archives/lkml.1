Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYIZTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYIZTOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYIZTOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:14:07 -0400
Received: from mail.tpi.com ([198.107.51.143]:2577 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbYIZTOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:14:06 -0400
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 15:14:06 EDT
Message-ID: <48DD2F98.8070509@tpi.com>
Date: Fri, 26 Sep 2008 12:53:12 -0600
From: Tim Gardner <timg@tpi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <48DCCC5F.8040609@linux.intel.com> <200809261052.38966.jbarnes@virtuousgeek.org> <200809261123.52198.jbarnes@virtuousgeek.org>
In-Reply-To: <200809261123.52198.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Friday, September 26, 2008 10:52 am Jesse Barnes wrote:
>> On Friday, September 26, 2008 4:49 am Arjan van de Ven wrote:
>>> Jiri Kosina wrote:
>>>> On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:
>>>>> this is the current set of patches that I have to help us debug
>>>>> and/or fix e1000e issues found during this debug effort for
>>>>> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches allow
>>>>> Thomas' patch for a mutex in the SWFLAG acquire function to run
>>>>> without any errors.
>>>> Thanks. Also Jesse Barnes' patch shouldn't be forgotten, could you
>>>> please add it to that lineup?
>>>>
>>>> 	http://marc.info/?l=linux-kernel&m=122237193628087&w=2
>>> can we (for now) also stick a WARN_ON() into that failure path? that way
>>> we can at least catch if/when this happens more visibly..... if it
>>> happens consistently in say the new distros we can be more confident that
>>> we're down the right path in diagnosing the issue.
>> I'm spinning a new one now with some debug output, stay tuned (just gotta
>> boot my test box).
> 
> Ok here's an updated one.  Jesse (Br) can you add it to your list?  If the X 
> driver really is mapping too much this should catch it, as long as it goes 
> through sysfs.
> 
> Thanks,
> Jesse
> 

I've been experimenting with unmapping flash space until its actually
needed, e.g., in the functions that use the E1000_READ_FLASH and
E1000_WRITE_FLASH macros. Along the way I looked at how flash write
cycles are initiated because I was having a hard time believing that
having flash space mapped was part of the root cause. However, it looks
like its pretty simple to initiate a write or erase cycle. All of the
required action bits in ICH_FLASH_HSFSTS and ICH_FLASH_HSFCTL must be 1,
and these 2 register are in the correct order if X was writing 0xff in
ascending order.

Just a thought.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
