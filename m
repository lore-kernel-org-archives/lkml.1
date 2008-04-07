Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYDGSqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYDGSqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYDGSp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:45:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39327 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbYDGSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:45:55 -0400
Message-ID: <47FA6BE1.6090306@sgi.com>
Date: Mon, 07 Apr 2008 11:45:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: modify show_shared_cpu_map in intel_cacheinfo
 v2
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>	 <20080405012447.770671000@polaris-admin.engr.sgi.com> <36ca99e90804070657t4435f1a2ldd78ad5bf5978550@mail.gmail.com>
In-Reply-To: <36ca99e90804070657t4435f1a2ldd78ad5bf5978550@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Sat, Apr 5, 2008 at 3:24 AM, Mike Travis <travis@sgi.com> wrote:
>>  --- linux-2.6.x86.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  +++ linux-2.6.x86/arch/x86/kernel/cpu/intel_cacheinfo.c
>>  @@ -593,14 +593,17 @@ static ssize_t show_size(struct _cpuid4_
>>
>>   static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>>   {
>>  +       unsigned long end = ALIGN((unsigned long)buf, PAGE_SIZE);
> May I suggest this:
> 
>            ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;

Hmm, that sounds great.  There were a number of different methods used in
the various places to provide for that extra '\n'! ;-)

> 
>>  +       if (len == 0)
>>  +               len = PAGE_SIZE;
> Than this is not necessary.
> 
>>  +
>>  +       if (len >= 2) {
>>  +               n = cpus_scnprintf(buf, len-2, this_leaf->shared_cpu_map);
>>  +               buf[n++] = '\n';
>>  +               buf[n] = '\0';
>>         }
>>         return n;
>>   }
> Apart from my suggestion and the use of cpus_scnprintf I think this patch is ok.
> 
> Bert
> 
> PS: sorry for the long delay.

Thanks!
Mike

