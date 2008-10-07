Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYJGKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYJGKLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJGKL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:11:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYJGKL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:11:26 -0400
Message-ID: <48EB3542.2060306@cn.fujitsu.com>
Date: Tue, 07 Oct 2008 18:09:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       systemtap@sourceware.org
Subject: Re: [PATCH] markers: fix missing modpost entry in Module.markers
References: <48EB032B.3070200@cn.fujitsu.com> <20081007154401.5A59.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081007154401.5A59.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi Lai
> 
> Have you seen "Markers in (non-module) kernel code?" thread?
> I think this patch and that patch treat the same issue.
> 

I didn't notice that thread.

> In addition, I think mathieu's patch is better.

I greed with you, Mathieu's patch is better.

Thanks.

> So, Could I hear your opinition for that?
> 
> 
>> commit d35cb360c29956510b2fe1a953bd4968536f7216 brought a bug.
>> marker points compiled in vmlinux are missing in Module.markers.
>>
>> # cat Module.markers
>> subsystem_event samples/markers/marker-example  integer %d string %s
>> subsystem_eventb        samples/markers/marker-example
>>
>> # stap -e 'probe kernel.mark("core_marker_format"){} '
>> semantic error: no match while resolving probe point kernel.mark("core_marker_format")
>> semantic error: no probes found
>> Pass 2: analysis failed.  Try again with more '-v' (verbose) options.
>>
>> This patch revert a part of d35cb360c29956510b2fe1a953bd4968536f7216.
>> Other parts have fixed duplicate modpost entry bug.
>>
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
>> index 418cd7d..3509142 100644
>> --- a/scripts/mod/modpost.c
>> +++ b/scripts/mod/modpost.c
>> @@ -1992,8 +1992,7 @@ static void read_markers(const char *fname)
>>  			mod->skip = 1;
>>  		}
>>  
>> -		if (!mod->skip)
>> -			add_marker(mod, marker, fmt);
>> +		add_marker(mod, marker, fmt);
>>  	}
>>  	return;
>>  fail:
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> 
> 
> 


