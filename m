Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZDPV1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZDPV1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZDPV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:27:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:50035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZDPV1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:27:40 -0400
Date: Thu, 16 Apr 2009 14:24:36 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: Please revert kobject_uevent UMH_NO_WAIT
Message-ID: <20090416212436.GA31113@suse.de>
References: <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils> <200904150328.n3F3S0F9083222@www262.sakura.ne.jp> <Pine.LNX.4.64.0904152036150.27354@blonde.anvils> <200904160046.n3G0ki9o028612@www262.sakura.ne.jp> <Pine.LNX.4.64.0904160551080.28048@blonde.anvils> <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp> <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 09:55:29PM +0100, Hugh Dickins wrote:
> Please revert commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7
> "kobject: don't block for each kobject_uevent".
> 
> Tetsuo Handa, running a kernel with CONFIG_DEBUG_PAGEALLOC=y
> and CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, has been hitting RCU
> detected CPU stalls: it's been spinning in the loop where do_execve()
> counts up the args (but why wasn't fixup_exception working? dunno).
> 
> The recent change, switching kobject_uevent_env() from UMH_WAIT_EXEC
> to UMH_NO_WAIT, is broken: the exec uses args on the local stack here,
> and an env which is kfreed as soon as call_usermodehelper() returns.
> It very much needs to wait for the exec to be done.
> 
> Or keep the UMH_NO_WAIT, and complicate the code to allocate and free
> these resources correctly?  No, as GregKH pointed out when making the
> commit, CONFIG_UEVENT_HELPER_PATH="" is a much better optimization -
> though some distros are still saying /sbin/hotplug in their .config,
> yet with no such binary in their initrd or their root.
> 
> Or...
> 
> [PATCH] revert kobject_uevent UMH_NO_WAIT
> 
> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Linus, I can do this in a tree of patches to send to you or you can do it
yourself, which ever is easier.

thanks,

greg k-h
