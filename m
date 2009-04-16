Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZDPVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZDPVan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZDPVad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:30:33 -0400
Received: from mga10.intel.com ([192.55.52.92]:44982 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbZDPVad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:30:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,200,1239001200"; 
   d="scan'208";a="448612108"
Message-ID: <49E7A377.3000901@linux.intel.com>
Date: Thu, 16 Apr 2009 14:30:31 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       alan@lxorguk.ukuu.org.uk, viro@ZenIV.linux.org.uk, jmorris@namei.org,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert kobject_uevent UMH_NO_WAIT
References: <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils> <200904150328.n3F3S0F9083222@www262.sakura.ne.jp> <Pine.LNX.4.64.0904152036150.27354@blonde.anvils> <200904160046.n3G0ki9o028612@www262.sakura.ne.jp> <Pine.LNX.4.64.0904160551080.28048@blonde.anvils> <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp> <Pine.LNX.4.64.0904162145130.645@blonde.anvils> <20090416212436.GA31113@suse.de>
In-Reply-To: <20090416212436.GA31113@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Apr 16, 2009 at 09:55:29PM +0100, Hugh Dickins wrote:
>> Please revert commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
>> "kobject: don't block for each kobject_uevent".
>>
>> Tetsuo Handa, running a kernel with CONFIG_DEBUG_PAGEALLOC=y
>> and CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, has been hitting RCU
>> detected CPU stalls: it's been spinning in the loop where do_execve()
>> counts up the args (but why wasn't fixup_exception working? dunno).
>>
>> The recent change, switching kobject_uevent_env() from UMH_WAIT_EXEC
>> to UMH_NO_WAIT, is broken: the exec uses args on the local stack here,
>> and an env which is kfreed as soon as call_usermodehelper() returns.
>> It very much needs to wait for the exec to be done.
>>
>> Or keep the UMH_NO_WAIT, and complicate the code to allocate and free
>> these resources correctly?  No, as GregKH pointed out when making the
>> commit, CONFIG_UEVENT_HELPER_PATH="" is a much better optimization -
>> though some distros are still saying /sbin/hotplug in their .config,
>> yet with no such binary in their initrd or their root.
>>
>> Or...
>>
>> [PATCH] revert kobject_uevent UMH_NO_WAIT
>>
>> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
as well

not worth the hassle if this breaks too much
