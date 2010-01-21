Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911Ab0AUSWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0AUSWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 13:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813Ab0AUSWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 13:22:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55591 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0AUSWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 13:22:48 -0500
Message-ID: <4B589B29.4040201@zytor.com>
Date: Thu, 21 Jan 2010 10:21:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, cacheinfo: Fix disabling of L3 cache indexes
References: <1263899279-30739-1-git-send-email-bp@amd64.org> <1263899279-30739-2-git-send-email-bp@amd64.org> <4B578C0E.5090709@zytor.com> <20100121163048.GB10321@aftab>
In-Reply-To: <20100121163048.GB10321@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 08:30 AM, Borislav Petkov wrote:
> 
> The preexisting code using wbinvd is a bug since wbinvd has to happen on
> a core which contains the L3 cache whose indices(!) we disable.
> 

OK, please make a note in the code as to why it is (if it is) correct
not to use the PV version here... I'm not sure the above explains why it
should invoke native_wbinvd() and not wbinvd() -- the fact that is has
to be done on the right CPU is another matter, of course.

> But yeah, a wbinvd smp version is a bit problematic since
> smp_call_function_* expects a function pointer which has a void *
> argument but native_wbinvd() has no args. By the way, there's a similar
> thing in <drivers/char/agp/intel-agp.c::do_wbinvd()>

Saw that, thank you for handling that.

>> Second, it's pretty obvious that the only reason for this function at
>> all is to provide a wrapper that can be passed to smp_call_function*().
>>  It would be a lot cleaner to have a small function wbinvd_on_cpu(cpu)
>> as a wrapper for the higher-order functionality.
> 
> Done, see my next patch series.
> 

I wrote some comments on that before I saw this reply.  I think it has
some code cleanliness issues (noted in comments), but otherwise it's a
lot better.

	-hpa


