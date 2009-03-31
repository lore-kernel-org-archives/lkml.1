Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZCaCpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZCaCpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759971AbZCaCpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:45:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52863 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833AbZCaCpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:45:24 -0400
Message-ID: <49D183BA.5020007@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 11:45:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D093F4.2080202@linux.intel.com>
In-Reply-To: <49D093F4.2080202@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> To turn it off you would need to disable the CMCI enable bit
> completely.

mce_threshold=0 discourages CMCI initialization.
The CMCI enable bits are kept in off states in this case.

> I have no problems in principle with a mce=nocmci that does that
> but that would be a different patch.

Now I have no strong reason to have threshold >1, so that's OK. 

> However I expect that this will be not a good idea to ever use on Nehalem
> class systems  at least because without CMCI the machine check code cannot
> handle shared banks correctly and you'll get duplicated events from them.
> And on non Nehalem systems there is no CMCI anyways, so it'll be always
> off.

One question is that even if one clears record in a shared bank, others
sharing the bank still can retrieve same record?  Or the duplication of
recored only happens if a shared bank is polled by multiple cpu in parallel
at same time?

So old kernel without CMCI support running on new Nehalem class system will
make duplicated records, right?
Doesn't it impact to current distro like RHEL5?


Thanks,
H.Seto

