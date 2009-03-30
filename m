Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZC3Jl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZC3Jl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbZC3Jlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:41:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:38959 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755477AbZC3Jlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="677096662"
Message-ID: <49D093F4.2080202@linux.intel.com>
Date: Mon, 30 Mar 2009 11:42:12 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu>
In-Reply-To: <20090328120825.GB14464@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Makes sense. CMCI is a new CPU feature so having boot controls to 
> disable it is generally a good idea - while still having old-style 
> MCE support in place.

That's not what the patch does unfortunately.

> Applied to tip:x86/mce2, thanks Hidetoshi!

If you fear that CMCI is misbehaving you would need a different option to turn
it off completely, setting the threshold doesn't help. For example there are
banks that only support threshold == 1 and when the enable bit is on
then no matter what value you write in there events will cause CMCIs. So
this patch cannot turn them off.

To turn it off you would need to disable the CMCI enable bit
completely.

I have no problems in principle with a mce=nocmci that does that
but that would be a different patch.

However I expect that this will be not a good idea to ever use on Nehalem
class systems  at least because without CMCI the machine check code cannot
handle shared banks correctly and you'll get duplicated events from them.
And on non Nehalem systems there is no CMCI anyways, so it'll be always off.

-Andi
