Return-Path: <linux-kernel-owner+w=401wt.eu-S939108AbXHMPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939108AbXHMPt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941793AbXHMOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:09:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:50089 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S945842AbXHMOJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:09:51 -0400
Message-ID: <46C06638.6010108@qumranet.com>
Date: Mon, 13 Aug 2007 17:10:00 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <200708131605.40479.borntraeger@de.ibm.com>
In-Reply-To: <200708131605.40479.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Freitag, 10. August 2007 schrieb Laurent Vivier:
>   
>> The aim of these two patches is to measure the CPU time used by a virtual
>> machine. All comments are welcome... I'm not sure it's the good way to do 
>>     
> that.
>
> I did something similar for or s390guest prototype, that Carsten posted in 
> May.  I decided to account guest time to the user process instead of adding a 
> new field to avoid hazzle with old top. As you can read in the patch comment, 
> I personally prefer a new field if we can get one.
>   

Laurent's patch gives the best of both worlds: on old 'top', you get 
guest time accounted as user time, while on new 'top' it is accounted 
separately.  This is done by reporting user time as the sum of the real 
user time and guest time.  A newer 'top' can subtract guest time from 
user time to get the correct statistic.


> My implementation uses a similar mechanism like hard and softirq. So I have an 
> sie_enter an sie_exit and a task_is_in_sie function - like irq_enter and 
> irq_exit. The main difference is based on the fact, that s390 has precise 
> accouting for irq, steal, user and system time, and therefore my patch is 
> based on architecture specifc code using CONFIG_VIRT_CPU_ACCOUNT. 
>   

Okay, so the code should be under that config option, and kvm should 
select it.


-- 
error compiling committee.c: too many arguments to function

