Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZGJMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZGJMqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbZGJMox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:44:53 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19946 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965AbZGJMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:44:52 -0400
Message-ID: <4A5737AA.7050208@gmail.com>
Date: Fri, 10 Jul 2009 15:44:26 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: dedekind@infradead.org, vimal singh <vimalsingh@ti.com>,
       linux-mtd@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
       david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 2:2][MTD][NAND]omap : Adding DMA mode support in nand
 prefetch/post-write
References: <63362.192.168.10.89.1247226916.squirrel@dbdmail.itg.ti.com>	 <1247227344.20721.363.camel@localhost.localdomain> <1247229621.29541.4.camel@macbook.infradead.org>
In-Reply-To: <1247229621.29541.4.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jul 2009 12:44:29.0141 (UTC) FILETIME=[2A473850:01CA015C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Fri, 2009-07-10 at 15:02 +0300, Artem Bityutskiy wrote:
>> On Fri, 2009-07-10 at 17:25 +0530, vimal singh wrote:
>>> +	/* The fifo depth is 64 bytes. We have a sync at each frame and frame
>>> +	 * length is 64 bytes.
>>> +	 */
>>> +	int buf_len = len/64;
>> To optimize performance it is better not to rely on gcc and use <<
> 
> If you ever see gcc screwing up division of an 'int' by a constant 64,
> file a GCC bug.

I did see gcc generated division instruction instead of shift
instruction on x86 when the kernel is compiles with size optimization.
I think this is because it division instruction is shorter.

The exact place I we saw was the UBIFS binary search function, and
division by 2 was not compiled into a shift instruction.

So what I suggested is to use shift explicitly if this is wanted.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
