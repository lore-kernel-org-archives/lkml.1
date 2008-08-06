Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbYHFBwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbYHFBwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 21:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbYHFBvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 21:51:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:56632 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYHFBvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 21:51:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xsKDVtU+5aIMERyk3E7qntrxrgID9D/3wptZEMicEpE+k1e8jCFej8+x6WIV3XBlR9
         Msa813uzQz+WoZfX7R1rcTOY1LPRL9VVdfhZ/DURbOn3rVb5gnhMdjKL50+9Gehrshht
         tycSXovOKLx0753L3zvOMKabOGrL+s/F14Tsg=
Message-ID: <a8e1da0808051851y752b3525l98271ceca4eb189a@mail.gmail.com>
Date: Wed, 6 Aug 2008 09:51:14 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080805122408.GA5000@hash.localnet>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 8:24 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Aug 05, 2008 at 09:29:26AM +0800, Dave Young wrote:
>> With the patch I cann't reproduce the bug with 27-rc1 now.
>>
>> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>> >  [<c02375a6>] debugfs_create_file+0x46/0x210
>> >  [<c02377f1>] debugfs_create_dir+0x21/0x30
>> >  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
>> >  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
>> >  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
>
> I wonder if there were two separate problems here.  I looked into
> this with some detail yesterday and agree with Johannes that the above
> trace is on locking the parent directory's i_mutex, but I too couldn't
> see any problems with sta_info_debugfs_add_work.  Other stuff could also
> modify the directory with or without rtnl_lock, but not in a way that
> to my untrained eyes would lead to deadlock.

Yes,. I think so. It's the original bug for me, while testing I found
the mutex deadlock problem.

But this week I will have no time to trace it. so if I have time I
will keep tracing the problem

>
> Or is the trace just wrong?
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>



-- 
Regards
dave
