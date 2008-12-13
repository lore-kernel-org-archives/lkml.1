Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYLMBVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYLMBVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYLMBVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:21:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:48441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYLMBVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:21:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,214,1228118400"; 
   d="scan'208";a="89727321"
Date: Sat, 13 Dec 2008 09:21:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081213012115.GA6250@localhost>
References: <20081212183810.GA4390@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212183810.GA4390@ics.muni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 07:38:10PM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> I noticed that in the current git head, the VM subsystem contains a serious
> bug - cached memory is newer freed:
> 
> # free; echo 3 > /proc/sys/vm/drop_caches; free
>              total       used       free     shared    buffers     cached
> Mem:       2016688     669172    1347516          0       2160     335120
> -/+ buffers/cache:     331892    1684796
> Swap:      1542232          0    1542232
>              total       used       free     shared    buffers     cached
> Mem:       2016688     659336    1357352          0        320     327288
> -/+ buffers/cache:     331728    1684960
> Swap:      1542232          0    1542232
> 
> the above sequence has been done on completly idle system so there is no
> reason for non freeing the cache.

I cannot reproduce it on 2.6.28-rc7, compiling 2.6.28-rc8...

# free; echo 3 > /proc/sys/vm/drop_caches; free
             total       used       free     shared    buffers     cached
Mem:          1940        109       1831          0          0         42
-/+ buffers/cache:         66       1873
Swap:            0          0          0
             total       used       free     shared    buffers     cached
Mem:          1940         62       1877          0          0          7
-/+ buffers/cache:         55       1884
Swap:            0          0          0

> once the whole memory is eaten by the cache, the system is pretty unusable.

What's your kconfig?

Thanks,
Fengguang

