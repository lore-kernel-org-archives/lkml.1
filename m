Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXB0OfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXB0OfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXB0OfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:35:10 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27818 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXB0OfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:35:08 -0500
Date: Tue, 27 Feb 2007 08:34:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: list.h , list_head and C++
In-reply-to: <1172571563.228792.208610@h3g2000cwc.googlegroups.com>
To: "remi.chateauneu@gmail.com" <remi.chateauneu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45E44165.4060608@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1172493644.311389.243780@8g2000cwh.googlegroups.com>
 <fa.K8OHlwttPU4TDDzMegRRFAIJrxw@ifi.uio.no>
 <fa.9RVekJKqUMy1lb5hfYQYDK8VxnE@ifi.uio.no>
 <1172571563.228792.208610@h3g2000cwc.googlegroups.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remi.chateauneu@gmail.com wrote:
> On Feb 26, 2:26 pm, Robert Hancock <hanco...@shaw.ca> wrote:
>> remi.chateau...@gmail.com wrote:
>>> My C++ program needs an intrusive list, possibly with RCU
>>> capabilities.The data structurelist_head, defined in /usr/include/
>>> linux/list.h , fits perfectly these needs.
>> You really shouldn't use kernel data structures in userspace.
>> The locking and other primitives they depend on are not guaranteed to work.
> The file starts with ' #ifdef KERNEL'  but what hurts me is
> duplicating code.
> Btw:
> - what are the fundamental reasons for not using C++ in the kernel ?

See the archives, this has been discussed before. Aside from some 
developers just not liking C++, the main problem area is that there are 
cases where C++ just does too much behind the programmer's back to be 
practical in a kernel, where things like stack usage are critical. Also, 
a number of C++ features like exceptions would be difficult to support.

> - what prevents the use of RCU lists in user mode ?

Some type of RCU list may be doable, but not with the same code. RCU 
needs to have a way of knowing that all old copies of a data structure 
are no longer in use. In the kernel this is done by checking if all CPUs 
have scheduled since accessing the structure, but that concept doesn't 
really exist in userspace.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

