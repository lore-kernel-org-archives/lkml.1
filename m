Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXE3TdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXE3TdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXE3TdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:33:09 -0400
Received: from stinky.trash.net ([213.144.137.162]:46618 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbXE3TdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:33:06 -0400
Message-ID: <465DD142.6040409@trash.net>
Date: Wed, 30 May 2007 21:32:18 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
References: <20070529180112.GC5411@linux-os.sc.intel.com> <20070530105936.6c988da5.akpm@linux-foundation.org> <20070530112056.0aeb9498@freepuppy> <465DC598.5060407@trash.net> <20070530191533.GB3216@linux-os.sc.intel.com>
In-Reply-To: <20070530191533.GB3216@linux-os.sc.intel.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> On Wed, May 30, 2007 at 08:42:32PM +0200, Patrick McHardy wrote:
> 
>>
>>It seems wasteful to add per-packet overhead for tx timeouts, which
>>should be an exception. Do drivers really care about the exact
>>timeout value? Compared to a packet transmission time its incredibly
>>long anyways ..
> 
> 
> I agree. Doing a mod_timer or hrtimer_forward to push forward may add to the
> complexity depending on how often TX happens.
> 
> Are the drivers really worried about exact timeouts here?


Just guessing, but I don't think they are, after all timers can be late.

> Can we use rounding for the timers that are more than a second, at least?


Also sounds reasonable.
