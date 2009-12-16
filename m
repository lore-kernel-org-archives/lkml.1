Return-Path: <linux-kernel-owner+w=401wt.eu-S935532AbZLPTFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532AbZLPTFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763032AbZLPTFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:05:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763027AbZLPTFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:05:16 -0500
Message-ID: <4B292F69.3000608@redhat.com>
Date: Wed, 16 Dec 2009 14:05:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
References: <20091216135448.GD11618@aftab> <1260988340.21028.198.camel@laptop>
In-Reply-To: <1260988340.21028.198.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Wed, 2009-12-16 at 14:54 +0100, Borislav Petkov wrote:
>> Hi,
>>
>> even after installing libdwarf-dev on my debian box here, make in tools/perf/
>> still complains that it cannot find libdwarf:
>>
>> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
>>
>> The problem is that the include path on debian is not
>> /usr/include/libdwarf/ but simply /usr/include because the debian
>> package libdwarf-dev puts the headers straight into /usr/include.
>>
>> Now, fixing this in the build system could get ugly and too much (see
>> below), IMHO, so how about adding a README file in <tools/perf/>
>> which explains that on Debian-like systems, one should mkdir
>> /usr/include/libdwarf/ and symlink libdwarf.h and dwarf.h into it?
>>
>> There could be a better solution though...?
> 
> Yeah, like file a bug with RH for placing them in such an utterly stupid
> location.
> 
> Also, I'd not bother with testing debian, just do
> 
> #include <dwarf.h>
> 
> and simply add -I/usr/include/libdwarf to CPPFLAGS or something like
> that.

Ah, right, I was stupid!

Masami Hiramatsu wrote:
> e.g.
> 
> ifeq ($(shell sh -c "(test -d /usr/include/libdwarf/ && echo y)", y)
> 	BASIC_CFLAGS += -I /usr/include/libdwarf 
> endif

So, it just need;

BASIC_CFLAGS += -I/usr/include/libdwarf 

And including just libdwarf.h and dwarf.h.


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

