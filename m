Return-Path: <linux-kernel-owner+w=401wt.eu-S1030760AbXDSAvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbXDSAvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030763AbXDSAvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:51:12 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:34345 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030760AbXDSAvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:51:11 -0400
Date: Wed, 18 Apr 2007 18:50:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: problem with <asm/semaphore.h>
In-reply-to: <1176885218.597268.304370@l77g2000hsb.googlegroups.com>
To: liangbowen <liangbowen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4626BCE5.6090109@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <1176885218.597268.304370@l77g2000hsb.googlegroups.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

liangbowen wrote:
> Hi
> 
> I compiled the following code with gcc under FC2 :
> 
> #include <asm/semaphore.h>
> main()
> {
>     struct semaphore sum;
> 
> }
> 
> It doesn't compile, saying "storage size of `sem'
> isn't known".
> 
> and I looked inside asm/semaphore.h, I saw:
> #ifndef I386_SEMAPHORE_H
> #define I386_SEMAPHORE_H
> 
> #include <linux/linkage.h>
> 
> #endif
> 
> Did I missed something? Please guide me how to fix it.
> 
> Sincerely

You're trying to use a kernel data structure in a user-space program. 
Don't. The definitions in that header are inside #ifdef __KERNEL__ and 
so the provided userspace headers remove that part.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

