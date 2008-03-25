Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYCYV6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYCYV6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYCYV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:58:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCYV6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:58:03 -0400
Message-ID: <47E97566.5020003@redhat.com>
Date: Tue, 25 Mar 2008 17:57:58 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "J.C. Pizarro" <jcpiza@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why /proc/cpuinfo doesn't print L1,L2,L3 caches?
References: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
In-Reply-To: <998d0e4a0803251439u4bf09fb1ye568fc1970b0200f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Pizarro wrote:
> $ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 47
> model name      : AMD Athlon(tm) 64 Processor 3200+
> ...
> cache size      : 512 KB
> ...
> 
> The cache size is currently misinformed. It's not the real size because
> it's 64+64+512 KiB = 640 KiB, not 512 KB.
> 
> How can i know what hw-caches use the processors?
> The current kernel doesn't know well what hw-caches uses.
> 
> The good proposal is by example (the data below are not real):
> * In old AMD Athlon64:
> 
> cache L1        : 64 KiB I + 64 KiB D, 64 B line, direct way, ...
> cache L2        : 512 KiB I+D-shared, exclusive, 128 associative way, ...
> cache L3        : none
> 
> * In Intel Core Duo:
> processor       : 0
> cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
> cache L2        : 2048 KiB Cores-shared, inclusive, 128 associative way, ...
> cache L3        : none
> 
> processor       : 1
> cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
> cache L2        : 2048 KiB cores-shared, inclusive, 128 associative way, ...
> cache L3        : none
> 
> * In Quad:
> processor       : 0
> cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
> cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
> associative way, ...
> cache L3        : none
> ...
> processor       : 3
> cache L1        : 32 KiB I + 32 KiB D, 64 B line, direct way, ...
> cache L2        : 2048+2048 KiB pair-cores-shared, inclusive, 128
> associative way, ...
> cache L3        : none
> 
> It above is an example, put your symbols to /proc/cpuinfo in a
> convenient manner.
> 
>    Good bye ;)

I think you want this:

/sys/devices/system/cpu/cpu0/cache

/proc/cpuinfo is intended to give a general summary of certain properties of the 
processor that tend to be particularly interesting, and present them all in one 
place.  It is not intended to expose everything the kernel knows about every 
processor on the system.

-- Chris
