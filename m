Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbXJGWSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbXJGWSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXJGWSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:18:17 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:41726 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbXJGWSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:18:16 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2007 18:18:15 EDT
From: Joshua Root <jmr@gelato.unsw.edu.au>
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 08 Oct 2007 08:10:47 +1000
X-Spam-Score: 0.35
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	tone.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
Message-ID: <47095967.8060608@gelato.unsw.edu.au>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
CC: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, btrace <linux-btrace@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux Kernel Markers - performance characterization with large
 IO load on large-ish system
References: <46F92219.9020406@hp.com> <20070925171349.GA6057@Krystal> <46FA7A86.6090804@hp.com> <20071007193256.GA18558@elte.hu>
In-Reply-To: <20071007193256.GA18558@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> actually, the pure marker overhead seems to be a regression:
> 
> Kernel Options       Min val    Avg val    Max val    Std Dev
>> - markers - bt cfg  15.349127  16.169459  16.372980   0.184417
>> + markers - bt cfg  15.280382  16.202398  16.409257   0.191861
> 
> why isnt the marker near zero-cost as it should be? (as long as they are 
> enabled but are not in actual use) 2% increase is _ALOT_.

The increase in the mean is actually 0.033, or 0.2%.

> So there's something wrong going on - either markers have unacceptably 
> high cost, or the measurement is not valid.

The third option is that the measurement just needs to be done more 
times. The standard error in the mean for the + markers case is
0.191861 / sqrt(10) = 0.061, which is twice the size of the difference 
being measured.
-- 
Joshua Root,  jmr AT gelato.unsw.edu.au
http://www.gelato.unsw.edu.au
