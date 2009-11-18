Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZKRRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZKRRnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZKRRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:43:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758062AbZKRRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:43:38 -0500
Message-ID: <4B04324D.6050508@sgi.com>
Date: Wed, 18 Nov 2009 09:43:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
References: <20091118002211.709343000@alcatraz.americas.sgi.com>	 <20091118002219.163869000@alcatraz.americas.sgi.com> <86802c440911171845v1dae0f27i78ee7347d0f315d0@mail.gmail.com>
In-Reply-To: <86802c440911171845v1dae0f27i78ee7347d0f315d0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Tue, Nov 17, 2009 at 4:22 PM, Mike Travis <travis@sgi.com> wrote:
>> When there are a large number of processors in a system, there
>> is an excessive amount of messages sent to the system console.
>> It's estimated that with 4096 processors in a system, and the
>> console baudrate set to 56K, the startup messages will take
>> about 84 minutes to clear the serial port.
>>
>> This set of patches limits the number of repetitious messages
>> which contain no additional information.  Much of this information
>> is obtainable from the /proc and /sysfs.   Some of the messages
>> are also sent to the kernel log buffer as KERN_DEBUG messages so
>> dmesg can be used to examine more closely any details specific to
>> a problem.
>>
>> The new cpu bootup sequence for system_state == SYSTEM_BOOTING:
>>
>> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
>> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
>> ..
>> Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
>> Brought up 64 CPUs
> 
> how about
> Booting Node   0, Processors  #1/0x01 #2/0x02 #3....
> append apic id in hex after the numbering.?
> 
> YH

The APIC id's are already listed earlier in the log.  There are
some other APIC patches to deal with making the output clearer
as well as more/less verbose.
