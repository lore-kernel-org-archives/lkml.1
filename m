Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbYDVOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbYDVOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYDVOi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:38:28 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:32222
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYDVOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:38:28 -0400
Message-ID: <480DF861.6000705@qumranet.com>
Date: Tue, 22 Apr 2008 17:38:25 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <480DACDD.7040108@qumranet.com> <20080422092230.GW12774@kernel.dk> <20080422111403.GX12774@kernel.dk> <1208869254.7115.258.camel@twins> <20080422142543.GG12774@kernel.dk>
In-Reply-To: <20080422142543.GG12774@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> Introducing this fallback will make any usage from irq disabled context
>> deadlock prone.
>>
>> I rather like the current interface.
>>     
>
> Hmm good point, I'll back that bit out again.
>   

But then you need to fix all callers to handle errors.

Perhaps we need a new flag for failable async IPIs (or better, API).  
I'm pretty sure no one uses s_c_f_s() from irq disabled context on x86, 
since it will WARN_ON(irqs_disabled()).

-- 
error compiling committee.c: too many arguments to function

