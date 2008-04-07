Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYDGSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYDGSWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYDGSWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:22:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751333AbYDGSWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:22:16 -0400
Message-ID: <47FA6653.4080707@sgi.com>
Date: Mon, 07 Apr 2008 11:22:11 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>	 <20080407030421.0c3f8033.pj@sgi.com> <36ca99e90804070707g41d374a5m9b80e77165534f1b@mail.gmail.com>
In-Reply-To: <36ca99e90804070707g41d374a5m9b80e77165534f1b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Mon, Apr 7, 2008 at 10:04 AM, Paul Jackson <pj@sgi.com> wrote:
>> I still have some concerns with this cpus_scnprintf patch.
>>
>>  I've taken them up with Mike offline for initial consideration.
>>
>>  If others have questions, concerns or enthusiasms for this patch,
>>  Mike and I would be interested.
> As long as the only justification for this cpus_scnprintf is human
> readability, I have concerns too.
> 
> Patch 2/4 itself is ok and 4/4 too. The only thing I miss is an export
> of NR_CPUS. So that you know in front of reading a kernel mask, what
> size your bitmap needs. (for example glibc cpu_set_t has only 1024
> bits but has an cpu_set_t with arbitrary size too).
> 
> Bert

Hi Bert,

Yes, sorry, I promised I'd follow up with you on what's happening.  I
did get some feedback on changes proposed but haven't yet tracked down
specific details yet.

Part of the change is readability, but also looking towards the future
of 16k/64k/??? # of cpus, the straight mask approach will overflow the
PAGE_SIZE buffer provided (though some pathological cases will overflow
the range method as well.)  So we'll need some advancement in the format
of the printout.

Another aspect is that this brings the cpumap and cpuset interfaces
closer as the latter already uses the range method.

Thanks,
Mike
