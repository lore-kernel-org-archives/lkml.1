Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYABSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYABSR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYABSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:17:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYABSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:17:49 -0500
Message-ID: <477BD517.2090301@kernel.org>
Date: Wed, 02 Jan 2008 10:16:55 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] linux/{socket,stat}.h: change __GLIBC__ cruft to __KLIBC__
References: <200801020937.50770.vapier@gentoo.org> <20080102151335.GA15898@does.not.exist> <200801021047.59006.vapier@gentoo.org>
In-Reply-To: <200801021047.59006.vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
>>>
>>> -#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
>>> +#if defined(__KERNEL__) || defined(__KLIBC__)
>>> ...
>> This changes the semantics from "!glibc" to "klibc".
> 
> that's the point
> 
>> I'm a bit worried that such changes might break some of the other
>> libc's people use on Linux.
> 
> such libc's are broken and it isnt the kernel's problem to cater to broken 
> libc's.  the problem is that these headers are breaking things *now* for 
> valid libc's that are not glibc.  removal of __GBLIC__ was already accepted 
> once but reverted for klibc.
> -mike

Either of these really is wrong... it's the userspace which should ask 
for what should be imported; the kernel shouldn't hard-code which libcs 
want what.

I just posted a patch to the netdev list which splits the top of 
<linux/socket.h> out into <linux/sockaddr.h>, userspace can choose to 
include one or the other.

	-hpa
