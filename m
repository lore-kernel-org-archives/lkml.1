Return-Path: <linux-kernel-owner+w=401wt.eu-S965208AbYD1RJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965208AbYD1RJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933728AbYD1RJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:09:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51326 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762368AbYD1RJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:09:19 -0400
Message-ID: <481604BD.7000009@sgi.com>
Date: Mon, 28 Apr 2008 10:09:17 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: WANG Cong <xiyou.wangcong@gmail.com>, bert.wesarg@googlemail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix calculus of bitmap_scnprintf_len()
References: <1209329003-22036-1-git-send-email-bert.wesarg@googlemail.com>	<20080427160118.ad4cadf0.pj@sgi.com>	<alpine.LFD.1.00.0804281414020.2870@localhost.localdomain> <20080428081326.fc62f1ce.pj@sgi.com>
In-Reply-To: <20080428081326.fc62f1ce.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Bert wrote:
>> The function bitmap_scnprintf_len() is currently not used
> 
> Paul Jackson wrote:
>> How about we just remove that function?
> 
> WANG Cong wrote:
>> I am afraid no. See:
>>
>> include/linux/cpumask.h:292:    return bitmap_scnprintf_len(len);
> 
> Good point.
> 
> 
> Then how about we also remove from cpumask.h:
> 
> #define cpumask_scnprintf_len(len) \
>                         __cpumask_scnprintf_len((len))
> static inline int __cpumask_scnprintf_len(int len)
> {
>         return bitmap_scnprintf_len(len);
> }
> 

That's fine with me.  A later version of the patch did have
the function removed but it didn't get picked up.  The other
changes there were to use function pointers instead of the
flag variable to select list or mask output format, and the
addition of mask variants for the cpu/{present,possible,
online,system} map outputs.

I'll dig that one back up and resubmit it.

Thanks,
Mike
