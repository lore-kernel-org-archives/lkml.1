Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbYBNUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbYBNUOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbYBNUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:14:01 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:44952 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbYBNUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:13:59 -0500
Date: Thu, 14 Feb 2008 13:33:10 -0600
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 3/4] IPMI: convert locked counters to atomics
In-reply-to: <20080214111143.7e0937ea.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>
Message-id: <47B49776.7000802@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080214183051.GC20148@minyard.local>
 <20080214111143.7e0937ea.akpm@linux-foundation.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +	for (i = 0; i < IPMI_NUM_STATS; i++)
>> +		atomic_set(&intf->stats[i], 0);
>>     
>
> And this is why it would be very hard for any architecture to ever
> implement atomic_t as
>
> struct atomic_t {
> 	int counter;
> 	spinlock_t lock;
> };
>
> The interface assumes that atomic_set() fully initialises the atomic_t, and
> that atomic_set() can be used agaisnt both an uninitialised atomic_t and
> against an already-initialised atomic_t.  IOW, we don't have atomic_init().
>
> So would our hypothetical future architcture's atomic_set() do spin_lock(),
> or would it do spin_lock_init()?  Either one is wrong in many atomic_set
> callsites.
>
> Oh well.
>   
Yeah, I thought the same thing when I did this.  Do we start working
on an atomic_init()?  It would be easy enough to set it to atomic_set()
for current architectures.

-corey
