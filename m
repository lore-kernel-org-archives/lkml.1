Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZKWS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZKWS5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZKWS5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:57:46 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36061 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZKWS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:57:45 -0500
Message-ID: <4B0ADA84.5050300@nortel.com>
Date: Mon, 23 Nov 2009 12:55:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Put printk buffer in video ram
References: <1258855506.3153.1.camel@maxim-laptop> <20091122023237.GA6572@nowhere> <20091122082511.GC24558@elte.hu> <1258892101.3231.20.camel@maxim-laptop> <1258938089.3134.22.camel@maxim-laptop> <20091123183220.GB24482@elte.hu>
In-Reply-To: <20091123183220.GB24482@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2009 18:57:29.0649 (UTC) FILETIME=[CE47BA10:01CA6C6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 12:32 PM, Ingo Molnar wrote:
> 
> * Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
>> On Sun, 2009-11-22 at 14:15 +0200, Maxim Levitsky wrote: 
>>> On Sun, 2009-11-22 at 09:25 +0100, Ingo Molnar wrote: 
>>>> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>>
>>>>> On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
>>>>>> After doing some successful debugging by placing printk buffer in video
>>>>>> ram, here I publish cleaned version of it.
>>>>>>
>>>>>> I discovered that on my system video ram isn't cleared on reboot, and I
>>>>>> took advantage of that by placing printk buffer directly there.
>>>>>> This allows to capture oopses/panicks almost from everywhere.
>>>>>> It is also very simple to setup.
>>
>> Few more thoughts:
>>
>> First of all, if I implement this as a console driver, I won't be able
>> to capture all kernel log, but only from the point I register the
>> console.
> 
> Adding an early console driver would solve this, right?

We've had a mechanism sort of like this for quite a while.  Hasn't been
pushed to mainline because it used board-specific hardware and we're
usually multiple kernel versions behind mainline.

Anyways, a couple things that we've found to be useful are:
1) The ability to allocate a chunk of this persistent memory area for a
special purpose.  This allows things like memory-mapped circular buffers
for per-cpu binary data.
2) An API to log just to this persistent area and bypass the normal
console completely.  This can be useful when debugging issues where the
normal logging paths result in a hang.

Chris
