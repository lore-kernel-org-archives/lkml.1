Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZECJKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZECJKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZECJJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:09:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbZECJJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:09:52 -0400
Message-ID: <49FD5E96.6060301@redhat.com>
Date: Sun, 03 May 2009 12:06:30 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 1/6] ksm: limiting the num of mem regions user can register
 per fd.
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>	<1241302572-4366-2-git-send-email-ieidus@redhat.com> <20090502220829.392b7ff9@riellaptop.surriel.com>
In-Reply-To: <20090502220829.392b7ff9@riellaptop.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Sun,  3 May 2009 01:16:07 +0300
> Izik Eidus <ieidus@redhat.com> wrote:
>
>   
>> Right now user can open /dev/ksm fd and register unlimited number of
>> regions, such behavior may allocate unlimited amount of kernel memory
>> and get the whole host into out of memory situation.
>>     
>
> How many times can a process open /dev/ksm?
>
> If a process can open /dev/ksm a thousand times and then
> register 1000 regions through each file descriptor, this
> patch does not help all that much...
>
>   
The idea is that the limitation is now on the maximum file descriptors 
user can open.
So for each such file descriptor user can open 1024 structures that are 
just few bytes each.

The whole propose of this patch is to avoid while (1) { 
IOCTL(REGISTER_MEMORY_REGION) } and oom the host.


