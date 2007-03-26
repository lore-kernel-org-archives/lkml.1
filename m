Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbXCZKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbXCZKcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXCZKcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:32:01 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:60056 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXCZKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:32:00 -0400
Message-ID: <4607A01D.1060401@hitachi.com>
Date: Mon, 26 Mar 2007 19:27:41 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, nikita@clusterfs.com,
       leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com> <46026B78.3080401@tmr.com>
In-Reply-To: <46026B78.3080401@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your reply.

>>3) Use "dirty_ratio" as the blocking ratio. And add
>>   "start_writeback_ratio", and start writeback at
>>   start_writeback_ratio(default:90) * dirty_ratio / 100 [%].
>>   In this way, specifying blocking ratio can be done in the same way
>>   as current kernel, but high/low watermark algorithm is enabled.
>I like 3 better, it should make tuning behavior more precise.

Then, what do you think of the following idea?

(4) add `dirty_start_writeback_ratio' as percentage of memory,
    at which a generator of dirty pages itself starts writeback
    (that is, non-blocking ratio).

In this way, `dirty_ratio' is used as the blocking ratio, so we don't
need to modify the sysctl.conf etc. I think it's easier to understand
for administrators of systems, because the interface is similar as
`dirty_background_ratio' and`dirty_ratio.'

If this is OK, I'll repost the patch.

> You can make an argument for absolute values for writeback,
> if my disk will only write 70MB/s I may only want 203 sec of
> pending writes, regardless of available memory.

To realize tuning with absolute values, I consider that we need to
modify handling of `dirty_background_ratio,' `dirty_ratio' and so on as
well as `dirty_start_writeback_ratio.' I think this should be done in
another patch if this feature is required.

Regards,
--
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory


