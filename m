Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYCZSPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYCZSPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCZSPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:15:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48121 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751878AbYCZSPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:15:09 -0400
Message-ID: <47EA92A9.9070808@sgi.com>
Date: Wed, 26 Mar 2008 11:15:05 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in	intel_cacheinfo
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com> <20080326065023.GG18301@elte.hu> <47EA6EA3.1070609@sgi.com> <47EA7633.1080909@goop.org> <47EA7958.6050202@sgi.com> <47EA80D5.1040002@goop.org>
In-Reply-To: <47EA80D5.1040002@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>> Hmm, I hadn't thought of that.  There is commonly a format spec called
>> %b for diags, etc. to print bit strings.  Maybe something like:
>>
>>     "... %*b ...", nr_cpu_ids, ptr_to_bitmap
>>
>> where the length arg is rounded up to 32 or 64 bits...?   
> 
> I think that would need to be %.*b, but I always need to try it both
> ways anyway...
> 
> But yes, that seems like the right way to go.

I had the same thought after hitting return.

But for this case, I was over thinking the problem.  Turns out that the
number of cpus in a leaf will be fairly small, even with new cpus around
the corner (maybe 64 or 128 cpu threads per leaf?)

So I dropped the cpumask_scnprintf_len() patch and have a new intel_cacheinfo
patch which I'll send in a separate message.

Thanks,
Mike
