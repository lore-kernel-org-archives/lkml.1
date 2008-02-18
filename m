Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYBRJUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYBRJUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYBRJUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:20:23 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34067 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYBRJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:20:21 -0500
Message-ID: <47B94D8C.8040605@bull.net>
Date: Mon, 18 Feb 2008 10:19:08 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
References: <20080211141646.948191000@bull.net>	<20080211141813.354484000@bull.net> <20080215215916.8566d337.akpm@linux-foundation.org>
In-Reply-To: <20080215215916.8566d337.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 11 Feb 2008 15:16:47 +0100 Nadia.Derbey@bull.net wrote:
> 
> 
>>[PATCH 01/08]
>>
>>This patch computes msg_ctlmni to make it scale with the amount of lowmem.
>>msg_ctlmni is now set to make the message queues occupy 1/32 of the available
>>lowmem.
>>
>>Some cleaning has also been done for the MSGPOOL constant: the msgctl man page
>>says it's not used, but it also defines it as a size in bytes (the code
>>expresses it in Kbytes).
>>
> 
> 
> Something's wrong here.  Running LTP's msgctl08 (specifically:
> ltp-full-20070228) cripples the machine.  It's a 4-way 4GB x86_64.
> 
> http://userweb.kernel.org/~akpm/config-x.txt
> http://userweb.kernel.org/~akpm/dmesg-x.txt
> 
> Normally msgctl08 will complete in a second or two.  With this patch I
> don't know how long it will take to complete, and the machine is horridly
> bogged down.  It does recover if you manage to kill msgctl08.  Feels like
> a terrible memory shortage, but there's plenty of memory free and it isn't
> swapping.
> 
> 
> 

Before the patchset, msgctl08 used to be run with the old msgmni value: 
16. Now it is run with a much higher msgmni value (1746 in my case), 
since it scales to the memory size.
When I call "msgctl08 100000 16" it completes fast.

Doing the follwing on the ref kernel:
echo 1746 > /proc/sys/kernel/msgmni
msgctl08 100000 1746

makes th test block too :-(

Will check to see where the problem comes from.

Rgards,
Nadia
