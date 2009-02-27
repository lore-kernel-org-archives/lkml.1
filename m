Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZB0Gh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZB0Gh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZB0GhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:37:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51303 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZB0GhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:37:13 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #12210] 2.6.28-rc8 big regression in VM
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       jbarnes@virtuousgeek.org, eric@anholt.net
In-Reply-To: <20090226180636.GE4374@ics.muni.cz>
References: <20081225112017.GB16080@localhost> <20090226180636.GE4374@ics.muni.cz>
Message-Id: <20090227153149.154B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 15:37:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
> 
> Also lsof reports many leaked file descriptors:
> lsof | grep drm | wc -l
> 7326

lsof output indicate any process don't close this files.
I would like to hear drm driver developer's opinion.
if many mapped file is unclosed, it seems misdesigned memory wasting.




