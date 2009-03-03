Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZCCCRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZCCCRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZCCCRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:17:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:8369 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZCCCRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:17:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,293,1233561600"; 
   d="scan'208";a="116039340"
Date: Tue, 3 Mar 2009 10:16:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "eric@anholt.net" <eric@anholt.net>
Subject: Re: [Bug #12210] 2.6.28-rc8 big regression in VM
Message-ID: <20090303021602.GA8149@localhost>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.2vG.c4_QJB@chimera> <20081225112017.GB16080@localhost> <20090226180636.GE4374@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226180636.GE4374@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On Thu, Feb 26, 2009 at 08:06:36PM +0200, Lukas Hejtmanek wrote:
> Hello,
> 
> you may remember that I reported regression in VM. I used you filecache module
> and discovered that the leaks are caused by these items:
> # filecache 1.0
> #      ino       size   cached cached% refcnt state dev          file
>     167302         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167301         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167300         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167299          4        4     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167290          8        8     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167289          8        8     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167288         16       16     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
>     167287         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
> 
> there are tons of those items:
> cat /proc/filecache  | grep drm | wc -l
> 14224
> 
> Do you have any clues what happens here? Is it a bug in kernel VM system or it
> is more likely a bug in Intel's GEM drm driver? Right now it results in 500MB
> of undropable cache.

Could you provide the full filecache listing(the 'size' field may
provide some info), and the contents in /proc/dri/0/*?

> Also lsof reports many leaked file descriptors:
> lsof | grep drm | wc -l
> 7326

Simply being "deleted" does not mean that they are leaked files.
shmem files are special.

Thanks,
Fengguang

