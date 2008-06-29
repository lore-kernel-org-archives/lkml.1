Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYF2Fiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYF2Fiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYF2Fip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:38:45 -0400
Received: from il.qumranet.com ([212.179.150.194]:48218 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYF2Fip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:38:45 -0400
Message-ID: <48671FF6.1070501@qumranet.com>
Date: Sun, 29 Jun 2008 08:39:02 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <486704AC.2090207@qumranet.com> <48671A12.90205@goop.org>
In-Reply-To: <48671A12.90205@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 29 Jun 2008 08:39:03 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>>>
>>> Yes, it's intended behaviour.  Filesystem IO syscalls are considered 
>>> "fast" and are interruptible.  Usermode code can reasonably expect 
>>> that file IO will never return EINTR.
>>
>> That's filesystem dependent; if you mount an nfs filesystem with the 
>> 'intr' mount option, it will be interruptible (which makes sense, as 
>> it is impossible to guarantee the server's responsiveness).
>
> 'intr' is a pretty bad idea, and I would never recommend it ('soft' is 
> better).  It's an excellent way to destroy data when a stray signal 
> causes a syscall to fail with EINTR in an unexpected way (write being 
> the obvious one, but link, unlink, truncate or even close can fail in 
> odd ways can cause havok).
>

Applications should not assume that write() (or other syscalls) can't 
return EINTR.  Not all filesystems have a bounded-time backing store.

'soft' has its own problems; namely false positives when someone steps 
on the network cable, temporarily blocking packet flow, or when using a 
clustered server which may take some time to recover from a fault.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

