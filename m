Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXCZRHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXCZRHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXCZRHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:07:15 -0400
Received: from mail.tmr.com ([64.65.253.246]:49441 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbXCZRHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:07:13 -0400
Message-ID: <4607FECD.1090101@tmr.com>
Date: Mon, 26 Mar 2007 13:11:41 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com> <46026B78.3080401@tmr.com> <4607A01D.1060401@hitachi.com>
In-Reply-To: <4607A01D.1060401@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomoki Sekiyama wrote:
> Hi,
> Thanks for your reply.
>
>   
>>> 3) Use "dirty_ratio" as the blocking ratio. And add
>>>   "start_writeback_ratio", and start writeback at
>>>   start_writeback_ratio(default:90) * dirty_ratio / 100 [%].
>>>   In this way, specifying blocking ratio can be done in the same way
>>>   as current kernel, but high/low watermark algorithm is enabled.
>>>       
>> I like 3 better, it should make tuning behavior more precise.
>>     
>
> Then, what do you think of the following idea?
>
> (4) add `dirty_start_writeback_ratio' as percentage of memory,
>     at which a generator of dirty pages itself starts writeback
>     (that is, non-blocking ratio).
>
> In this way, `dirty_ratio' is used as the blocking ratio, so we don't
> need to modify the sysctl.conf etc. I think it's easier to understand
> for administrators of systems, because the interface is similar as
> `dirty_background_ratio' and`dirty_ratio.'
>
> If this is OK, I'll repost the patch.
>   
It sounds good to me, just be sure behavior is sane for for both 
blocking less than start_writeback and vice versa.
>   
>> You can make an argument for absolute values for writeback,
>> if my disk will only write 70MB/s I may only want 203 sec of
>> pending writes, regardless of available memory.
>>     
>
> To realize tuning with absolute values, I consider that we need to
> modify handling of `dirty_background_ratio,' `dirty_ratio' and so on as
> well as `dirty_start_writeback_ratio.' I think this should be done in
> another patch if this feature is required.
>
> Regards,
> --
> Tomoki Sekiyama
> Hitachi, Ltd., Systems Development Laboratory
>
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

