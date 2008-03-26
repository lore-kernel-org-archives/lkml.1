Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYCZQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYCZQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYCZQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:59:05 -0400
Received: from gw.goop.org ([64.81.55.164]:42441 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725AbYCZQ7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:59:04 -0400
Message-ID: <47EA80D5.1040002@goop.org>
Date: Wed, 26 Mar 2008 09:59:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 06/10] x86: reduce memory and stack usage in	intel_cacheinfo
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.683748000@polaris-admin.engr.sgi.com> <20080326065023.GG18301@elte.hu> <47EA6EA3.1070609@sgi.com> <47EA7633.1080909@goop.org> <47EA7958.6050202@sgi.com>
In-Reply-To: <47EA7958.6050202@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Hmm, I hadn't thought of that.  There is commonly a format spec called
> %b for diags, etc. to print bit strings.  Maybe something like:
>
> 	"... %*b ...", nr_cpu_ids, ptr_to_bitmap
>
> where the length arg is rounded up to 32 or 64 bits...? 
>   

I think that would need to be %.*b, but I always need to try it both 
ways anyway...

But yes, that seems like the right way to go.

>> Eh?  What's the difference between snprintf and scnprintf?
>>     
>
> Good question... I'll have to ask the cpumask person. ;-)
>   

It's in generic lib/vsprintf.c.  The two functions are pretty much 
identical...  Oh, I see; snprintf returns the total output size, 
regardless of whether it fits into the provided buffer, but scnprintf 
returns the actual output size, clipped by the buffer length.

    J
