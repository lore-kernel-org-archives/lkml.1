Return-Path: <linux-kernel-owner+w=401wt.eu-S934681AbXK3B5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbXK3B5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763825AbXK3B45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:56:57 -0500
Received: from [222.73.24.84] ([222.73.24.84]:55130 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763817AbXK3B44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:56:56 -0500
Message-ID: <474F6D4D.9010006@cn.fujitsu.com>
Date: Fri, 30 Nov 2007 09:54:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org
Subject: Re: Trailing periods in kernel messages
References: <474E6BD0.20103@cn.fujitsu.com>	 <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>	<474E8669.6060409@cn.fujitsu.com>	 <200711291120.19595.elendil@planet.nl>	 <20071129032036.4c021617.akpm@linux-foundation.org>	 <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost>
In-Reply-To: <1196386259.22120.101.camel@localhost>
Content-Type: text/plain; charset=x-user-defined
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Fri, 2007-11-30 at 09:12 +0800, Li Zefan wrote:
>> Just a roughly grep:
>> # grep -r -P --include=*.[ch] 'printk.*\.\\n' * | wc -l
>> 6025
>> # grep -r -P --include=*.[ch] '\.\\n' * | wc -l
>> 12723
> 
> Inequivalent.
> 
> Try:
> 	grep -rP --include=*.[ch] 'printk.*\.\\n' * | wc -l
> and
> 	grep -rp --include=*.[ch] 'printk.*[^\.]\\n' * | wc -l
> 
> 6k/38k
> 

My 2nd grep finds out how many strings are terminated with '.'.
Those strings may finally pass to prink().

So it doesn't deserve the effort to eliminate these periods, isn't it?
Or we can add a check to checkpatch.pl to prevent new ones.
