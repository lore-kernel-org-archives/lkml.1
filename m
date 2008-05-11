Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYEKABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYEKABU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYEKABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 20:01:10 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:41299 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbYEKABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 20:01:09 -0400
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
To: Matthew <jackdachef@gmail.com>
Date: Sun, 11 May 2008 10:00:59 +1000
Message-ID: <4826373B.8090408@cse.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: Fabio Checconi <fabio@gandalf.sssup.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline
 and noop
References: <e85b9d30805101218u4b8f0c2bw47af2384133a5c77@mail.gmail.com>	 <20080510200053.GA78555@gandalf.sssup.it> <e85b9d30805101339je48a55dnd2fbd5601c27a3be@mail.gmail.com>
In-Reply-To: <e85b9d30805101339je48a55dnd2fbd5601c27a3be@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew wrote:
>> 2) Does using a bigger value of slice_idle increase the throughput?
> 
> [..]
>
> 2) a bigger value even made it worse, setting it to "0" however
> seemingly "fixed" it, I however don't know how the overall
> effect/impact is, this will need some more real-world testing ;)

As Fabio said, you may lose throughput if you have multiple processes
with at least one sync. seq. reader.  However, for other workloads, you
should see a large global throughput improvement.  This is because CFQ
tends to idle without too much regard to thinktime or seekiness, often
wasting a few ms.  The trade-off is that your slow sync. processes may
suffer a little.

 -- Aaron
