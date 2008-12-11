Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYLKOA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYLKOA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 09:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbYLKOAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 09:00:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:18088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYLKOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 09:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JDT0S31tEYzWmFmubQcEqS7xuER+lzt2YBZcFtBxwG4a2LFYQhqLdyM735YoEbOi/9
         irL267uEHvWhiLzhusq7GvjHLMt9NcHwN2Q0E2IoUqBHQdM+4JYNtYQx90od7rcmzSz1
         a5IniFBp14AfPq18ui+dPTNsO36E8m0gjZnxc=
Message-ID: <661de9470812110600i6097ca0q7a2d7250f6c493dc@mail.gmail.com>
Date: Thu, 11 Dec 2008 19:30:46 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] memcg: show real limit under hierarchy
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081211122237.4FF7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211121135.e00f6a2d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20081211122237.4FF7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Google-Sender-Auth: 3cc53903377f325a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 8:54 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> I wonder other people who debugs memcg's hierarchy may use similar patches.
>> this is my one.
>> comments ?
>> ==
>> From:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> Show "real" limit of memcg.
>> This helps my debugging and maybe useful for users.
>>
>> While testing hierarchy like this
>>
>>       mount -t cgroup none /cgroup -t memory
>>       mkdir /cgroup/A
>>       set use_hierarchy==1 to "A"
>>       mkdir /cgroup/A/01
>>       mkdir /cgroup/A/01/02
>>       mkdir /cgroup/A/01/03
>>       mkdir /cgroup/A/01/03/04
>>       mkdir /cgroup/A/08
>>       mkdir /cgroup/A/08/01
>>       ....
>> and set each own limit to them, "real" limit of each memcg is unclear.
>> This patch shows real limit by checking all ancestors in memory.stat.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Great!
>
> I hoped to use this patch at hierarchy inactive_ratio debugging ;)

I like this very much too

I would prefer to use

min_limit = min(tmp, min_limit); and similarly for min_memsw_limit

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
