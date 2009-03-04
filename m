Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZCDJ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZCDJ5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCDJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:57:38 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:47243 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZCDJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:57:37 -0500
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: drop_caches ...
Date: Wed, 4 Mar 2009 10:57:33 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903041057.34072.M4rkusXXL@web.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/OIzFeXypNTBLuGjfCT3CA0bv7o1zpsfirAZlt
	6WEzDXevM+kRjVRqkG5hlj1k1sS6nyqKZO9aTDHSCvolaSI7/N
	BlPOYXiQo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a small problem. Maybe its just a misunderstanding but I cant 
solve it.

I think that writing "3" to drop_caches should drop all buffers and 
caches which are already written. So its recommended to put a "sync" 
infront of it.
So I did "free -m ; sync ; echo 3 > /proc/sys/vm/drop_caches ; free -m"
And it gave me:
             total       used       free     shared    buffers     
cached
Mem:          3950       3922         28          0          1        
879
-/+ buffers/cache:       3041        909
Swap:         5342        205       5136
             total       used       free     shared    buffers     
cached
Mem:          3950       3907         43          0          0        
864
-/+ buffers/cache:       3041        908
Swap:         5341        206       5135

So the buffer was 1 and is 0 afterthat. But cached is at 879 MB before 
and is still 864 MB (!!!) after that!

I am at swappiness=0 and when I remove and readd one swap-partition 
after another (so there is always swap). It will keep the cached and 
put the swapped memory on other swaps?!

I _think_ thats not the way it should go?

It would be really kind if someone could explain that issue and 
what "cached" is at all!

Have a nice day...
Markus

PS: Please CC me as I am not subscribed.
