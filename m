Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbYHFBxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbYHFBxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbYHFBxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:53:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:57299 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841AbYHFBxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FfUHPUZZ/v0Jj0ZSMtXj9nkPw0ydEG5T5JSM9HGZz9/YTzF+sWBHgG+aii5NrwrUd2
         /cY9Y7NsPzdOYDHjn2fKpMmzPaj1XQflrQv0RCTr0Yv9UKKPU7+wh+LpCqeiH4As01di
         YFJbzfbZ45NUmOloRdU5W/ZWIJSAkk7GV/Om4=
Message-ID: <a8e1da0808051853x67b2739eh28104ac76b53486c@mail.gmail.com>
Date: Wed, 6 Aug 2008 09:53:21 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <a8e1da0808051851y752b3525l98271ceca4eb189a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com>
	 <4896D34A.1000005@gmail.com>
	 <a8e1da0808041829sac34939yd9163b02e6b8b515@mail.gmail.com>
	 <20080805122408.GA5000@hash.localnet>
	 <a8e1da0808051851y752b3525l98271ceca4eb189a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 9:51 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Aug 5, 2008 at 8:24 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Tue, Aug 05, 2008 at 09:29:26AM +0800, Dave Young wrote:
>>> With the patch I cann't reproduce the bug with 27-rc1 now.
>>>
>>> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>>> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>>> >  [<c02375a6>] debugfs_create_file+0x46/0x210
>>> >  [<c02377f1>] debugfs_create_dir+0x21/0x30
>>> >  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
>>> >  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
>>> >  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
>>
>> I wonder if there were two separate problems here.  I looked into
>> this with some detail yesterday and agree with Johannes that the above
>> trace is on locking the parent directory's i_mutex, but I too couldn't
>> see any problems with sta_info_debugfs_add_work.  Other stuff could also
>> modify the directory with or without rtnl_lock, but not in a way that
>> to my untrained eyes would lead to deadlock.
>
> Yes,. I think so. It's the original bug for me, while testing I found
> the mutex deadlock problem.
>
> But this week I will have no time to trace it. so if I have time I
> will keep tracing the problem

Additional info,

With the mutex fix patch, in 2.6.27-rc1 I seems can not reproduce the
debugfs_add bug, (maybe need more test)

But with 2.6.26, the bug can be reproduced. (The mutex fix patch need
not to be applied because there's no such deadlock bug)

>
>>
>> Or is the trace just wrong?
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
