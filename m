Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZDGKji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZDGKji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZDGKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:39:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZDGKj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:39:28 -0400
Message-ID: <49DB2D14.5010603@redhat.com>
Date: Tue, 07 Apr 2009 13:38:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Apollon Oikonomopoulos <ao-lkml@noc.grnet.gr>,
       linux-kernel@vger.kernel.org
Subject: Re: Block device cache issue
References: <20090402145205.GG30077@apollon.noc.grnet.gr> <20090407003153.41fb9c78.akpm@linux-foundation.org>
In-Reply-To: <20090407003153.41fb9c78.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
>> should it perhaps be the case that the partition's buffers somehow be 
>> linked with those of the containing device, or even be part of them? I 
>> don't even know if this is possible without significant overhead in the 
>> page cache (of which my understanding is very shallow), but keep in mind 
>> that this behaviour almost led to filesystem corruption (luckily we only 
>> changed a single file and hit a single inode).
>>     
>
> It would incur overhead.  We could perhaps fix it by having a single
> cache for /dev/sda and then just making /dev/sda1 access that cache
> with an offset.

The offset can be non PAGE_SIZE aligned (and usually isn't, 63 sectors 
difference with normal partitioning).

-- 
error compiling committee.c: too many arguments to function

