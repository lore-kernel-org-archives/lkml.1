Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbZBZSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbZBZSGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZBZSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:06:41 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:49650 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZBZSGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:06:40 -0500
Date: Thu, 26 Feb 2009 19:06:36 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       jbarnes@virtuousgeek.org, eric@anholt.net
Subject: Re: [Bug #12210] 2.6.28-rc8 big regression in VM
Message-ID: <20090226180636.GE4374@ics.muni.cz>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.2vG.c4_QJB@chimera> <20081225112017.GB16080@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081225112017.GB16080@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 26 Feb 2009 19:06:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

you may remember that I reported regression in VM. I used you filecache module
and discovered that the leaks are caused by these items:
# filecache 1.0
#      ino       size   cached cached% refcnt state dev          file
    167302         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167301         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167300         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167299          4        4     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167290          8        8     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167289          8        8     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167288         16       16     100      1    -- 00:08(tmpfs) /drm\040mm\040object\040(deleted)
    167287         16       16     100      1    d- 00:08(tmpfs) /drm\040mm\040object\040(deleted)

there are tons of those items:
cat /proc/filecache  | grep drm | wc -l
14224

Do you have any clues what happens here? Is it a bug in kernel VM system or it
is more likely a bug in Intel's GEM drm driver? Right now it results in 500MB
of undropable cache.

Also lsof reports many leaked file descriptors:
lsof | grep drm | wc -l
7326

-- 
Luká¹ Hejtmánek
