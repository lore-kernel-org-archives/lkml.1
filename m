Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZAIPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZAIPIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZAIPHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:07:53 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54517 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZAIPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:07:52 -0500
Subject: Re: [git pull] drm
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 15:07:35 +0000
Message-Id: <1231513655.5317.30.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just updated to the latest kernel from git to test some other patches
and after logging into GDM the X server hangs before launching the
desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
(i915 graphics). Bisection shows this happens after applying this
commit:

On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
> Please pull the 'drm-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
[...]
> commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Nov 28 14:22:24 2008 +1000
> 
>     drm: move to kref per-master structures.
>     
>     This is step one towards having multiple masters sharing a drm
>     device in order to get fast-user-switching to work.
>     
>     It splits out the information associated with the drm master
>     into a separate kref counted structure, and allocates this when
>     a master opens the device node. It also allows the current master
>     to abdicate (say while VT switched), and a new master to take over
>     the hardware.
>     
>     It moves the Intel and radeon drivers to using the sarea from
>     within the new master structures.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>

Is this issue known? I'm presuming my userspace should continue to work
after that change! :)

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

