Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYK2IIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYK2IIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 03:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYK2IHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 03:07:50 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43734 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYK2IHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 03:07:49 -0500
Message-ID: <4930F82B.7030906@cosmosbay.com>
Date: Sat, 29 Nov 2008 09:07:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes	allocation/deallocation
 on SMP
References: <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com> <20081128180318.GL10487@elte.hu> <1227898076.7392.16.camel@twins> <20081129063816.GA869@infradead.org>
In-Reply-To: <20081129063816.GA869@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 29 Nov 2008 09:07:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig a écrit :
> On Fri, Nov 28, 2008 at 07:47:56PM +0100, Peter Zijlstra wrote:
>>> Wow, that's incredibly impressive! :-)
>> Yeah, we got a similar speedup on -rt by pushing those super-block files
>> list into per-cpu lists and doing crazy locking on them.
>>
>> Of course avoiding them all together, like done here is a nicer option
>> but is sadly not a possibility for regular files (until hch gets around
>> to removing the need for the list).
> 
> We should have finished this long ago, thanks for the reminder.
> 
> 

inode_in_use could be percpu, at least.

Or just zap it, since we never have to scan it.

