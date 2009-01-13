Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZAMFCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZAMFCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZAMFCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:02:05 -0500
Received: from mga07.intel.com ([143.182.124.22]:32863 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750765AbZAMFCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:02:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,257,1231142400"; 
   d="scan'208";a="99301590"
Message-ID: <496C2060.4070205@linux.intel.com>
Date: Tue, 13 Jan 2009 06:02:24 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tim Hockin <thockin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       priyankag@google.com, Aaron Durbin <adurbin@gmail.com>,
       Duncan Laurie <dlaurie@google.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <b3ece790901121402k4e84f8e7k7993b5fda90456cb@mail.gmail.com>
In-Reply-To: <b3ece790901121402k4e84f8e7k7993b5fda90456cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Hockin wrote:

> 
>>  - it squeezes all MCE errors from the whole system into a small,
>>    32-entry ringbuffer.
> 
> Yes 32 is small, but not really a big problem in practice.  The MCE daemon
> (http://mcedaemon.googlecode.com)

Interesting.

> goes a long way towards making this
> a non-issue.  Every distro should ship mced.

The latest mcelog version (not yet released) also supports a daemon
mode btw. But the limited buffer has been also fixed already
here and replaced with more flexible per CPU buffers.

>>  - it puts all the MCE logging info into an intermediary binary log
>>    record format: 'struct mce' - just for userspace to in essence
>>    printf out those entries with minimal post-processing. The fact that
>>    we squeeze all information into a fixed-size binary record makes it
>>    hard to extend and complicates the code needlessly.
> 
> This is not true, we do EXTENSIVE post-processing of MCEs.  Yes it is hard
> to extend, but that's not the same as saying it is useless.

It's not hard to extend at all (I did it several times)
Adding fields is extremly simple and fully forwards and
backwards compatible. That works because mcelog asks
the kernel about the record size and just ignores any
excess data.

The only thing that cannot be done is removing old fields, but
that is difficult with ASCII parsers too (text parsers tend
to bail out when they can't find some field they expect)

They can be obsoleted fine however (happened with cpu -> extcpu)

> 
>>  - these design aspects are also quite harmful to usability: by
>>    default all MCEs are fatal currently (pre-Nehalem anyway), so
>>    /dev/mcelog will only be used if a user goes out on a limb to
>>    configure it and sets the tolerant flag.
> 
> Not true.  The vast vast vast majority of MCEs are corrected, as per our
> experience, and I suspect we've got more experience with MCEs than just
> about any other consumer.

My employer has a lot of experience with MCEs too...  And it matches your
experience.

-Andi
