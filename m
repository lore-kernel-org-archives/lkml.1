Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZIADNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZIADNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 23:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZIADNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 23:13:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59626 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZIADNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 23:13:37 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5726"; a="22926138"
Message-ID: <4A9C9163.50907@codeaurora.org>
Date: Mon, 31 Aug 2009 23:13:39 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org> <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain> <4A9A1701.2070703@codeaurora.org> <alpine.LFD.2.00.0908301016230.19335@localhost.localdomain> <4A9B4ECB.7070506@codeaurora.org> <alpine.LFD.2.00.0908310854020.19335@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908310854020.19335@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

>> This looks very good ! Our results are almost similar now. However, I think
>> that with this new
>> patch we're still arming the timer needlessly at least once. This is the
>> case when we're trying to remove the first (oldest) hrtimer with
>> timer->expires = cpu->expires_next, but we forgo the reprogramming, when we
>> really shouldn't. At this point, with the current scheme of things, we will
>> needlessly wakeup and simply correct the expires_next value by
>> traversing up the rbtree, to the parent node.
>>     
>
> That only happens, when that timer is the last one in both trees. Then
> the resulting reprogramming value is KTIME_MAX and we skip the
> reprogramming. That's easy to fix by removing the KTIME_MAX check.
>  
>   
Hmm. Agreed. I'll fix this and send a patch in the next few days. Otherwise, I think all else looks good.


Cheers,
Ashwin

