Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbXIDJhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbXIDJhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXIDJhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:37:48 -0400
Received: from main.gmane.org ([80.91.229.2]:52194 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXIDJhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:37:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: huge improvement with per-device dirty throttling
Date: Tue, 04 Sep 2007 11:37:36 +0200
Message-ID: <46DD2760.3040505@wldelft.nl>
References: <1187764638.6869.17.camel@hannibal> <p733aybzv6e.fsf@bingen.suse.de> <20070822124736.GQ13915@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: wl10583.wldelft.nl
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
In-Reply-To: <20070822124736.GQ13915@v2.random>
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Wed, Aug 22, 2007 at 01:05:13PM +0200, Andi Kleen wrote:
>> Ok perhaps the new adaptive dirty limits helps your single disk
>> a lot too. But your improvements seem to be more "collateral damage" @)
>>
>> But if that was true it might be enough to just change the dirty limits
>> to get the same effect on your system. You might want to play with
>> /proc/sys/vm/dirty_*
> 
> The adaptive dirty limit is per task so it can't be reproduced with
> global sysctl. It made quite some difference when I researched into it
> in function of time. This isn't in function of time but it certainly
> makes a lot of difference too, actually it's the most important part
> of the patchset for most people, the rest is for the corner cases that
> aren't handled right currently (writing to a slow device with
> writeback cache has always been hanging the whole thing).


Self-tuning > static sysctl's. The last years we needed to use very 
small values for dirty_ratio and dirty_background_ratio to soften the 
latency problems we have during sustained writes. Imo these patches 
really help in many cases, please commit to mainline.

-- 
Leroy

