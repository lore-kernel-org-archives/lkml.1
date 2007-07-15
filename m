Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXGORrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXGORrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbXGORrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:47:25 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36388 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495AbXGORrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:47:24 -0400
Message-ID: <469A5D7C.5010904@gmail.com>
Date: Sun, 15 Jul 2007 19:46:36 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it> <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>
In-Reply-To: <E1IA7j1-0000j9-I3@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2007 07:17 PM, Bodo Eggert wrote:

> Matt Mackall <mpm@selenic.com> wrote:
>> On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:
> 
>>> As far as I'm aware, the actual reason for 4K stacks is that after the
>>> system has been up and running for some time getting "1 physically
>>> contiguous pages" becomes significantly easier than 2 which wouldn't be
>>> arbitrary.
>> 
>> If there are exactly two free pages in the system, the odds of them
>> being buddies (ie adjacent AND properly aligned) is quite small. The
>> available page pool has to grow quite a bit before the availability of
>> order-1 page pairs approaches 100%.
> 
> If there are exactly two free pages in a system, the odds of starting any
> program are not very good. You'll have to swap, and if you do, you can swap
> two more pages in order to free enough RAM for the stack.

A thread's kernel stack is a kernel allocation. If you'd fail to allocate it 
you'd supposedly _already_ have swapt out everything that could be swapped out.

Moreoveover -- literally two pages free was hardly his point. The point is 
just that (with a page being the allocation unit) single page allocations 
are guaranteed to succeed if _any_ memory is free, while two adjacent (yes, 
and stacksize aligned) pages will be pretty hard to get by once the system 
has been up and running for some time.

Rene.

