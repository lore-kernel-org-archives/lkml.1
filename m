Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbZATB0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbZATB0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZATBZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:25:58 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31667 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZATBZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:25:57 -0500
Message-ID: <49752823.9020403@ct.jp.nec.com>
Date: Mon, 19 Jan 2009 17:25:55 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com>
In-Reply-To: <49751BA0.1040004@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:
> Justin P. Mattock wrote:
>> Justin Madru wrote:
>>> So far only a connection to talkgadget.google.com or the 2 tabs in 
>>> preferences make firefox crash.
>>> Other than that I've yet to run into another site that makes it 
>>> crash, and can browse just fine.
>>> Actually, other than this bug .29-rc2 is running rather nicely ;-)
>>>
>>> Ok, this time I maded sure I uninstalled/disabled everything I could.
>>> Sill.... same results. So, I decided to try something different. Test 
>>> with Epiphany.
>>> I tried both with the geko and webkit backends.
>>> Same results, a crash when going to my iGoogle page that has google 
>>> talk applet.
>>>
>>> But, this time epiphany left an error to the console that gives a 
>>> clue to the cause:
>>>
>>> $ epiphany-webkit                                                ** 
>>> (epiphany-webkit:9016): WARNING **: Cannot extract frame (0,0) from 
>>> the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (36,0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (72,0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (108, 0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (144, 0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (180, 0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (216, 0) 
>>> from the grid
>>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (252, 0) 
>>> from the grid
>>> console message:  @1: Unsafe JavaScript attempt to access frame with URL
>>> http://1.gmodules.com/ig/ifr?view=home&url=http://www.google.com/ig/modules/youtube_igoogle/v2/youtube.xml&nocache=0&up_title=YouTube&up_username=&up_prefs_version=0&up_search_channels=0&up_search_channel_name0=&up_search_channel_url0=&up_search_channel_name1=&up_search_channel_url1=&up_search_channel_name2=&up_search_channel_url2=&up_current_channel_id=0&up_rawQuery=&up_channel_url_to_preload=http://gdata.youtube.com/feeds/api/standardfeeds/US/recently_featured%3Falt%3Djson&lang=en&country=us&.lang=en&.country=us&synd=ig&mid=1&ifpctok=-8098139156870189641&parent=http://www.google.com&extern_js=/extern_js/f/CgJlbhICdXMrMBU4ACw/BrDZK7EjJT4.js 
>>>
>>> from frame with URL
>>> http://www.google.com/ig/ifpc_relay#%22remote_iframe_1%22&0&1&0&%22%2522remote_iframe_1%2522%26%2522resize_iframe%2522%26%2522%2522%26%2522%2522%26%2522remote_iframe_1%2522%26369%26%25221%2522%22&true. 
>>>
>>> Domains, protocols and ports must match.
>>> console message:  @1: Unsafe JavaScript attempt to access frame
>>> with URL http://www.google.com/ig from frame with URL
>>> http://talkgadget.google.com/talkgadget/mole?id=gth-hover-card&hl=en#id=gth-hover-card. 
>>>
>>> Domains, protocols and ports must match.
>>> console message:  @1: Unsafe JavaScript attempt to access frame
>>> with URL http://www.google.com/ig from frame with URL
>>> http://talkgadget.google.com/talkgadget/blank. Domains,
>>> protocols and ports must match.
>>> Segmentation fault
>>>
>>> So, it's complaining about matching domains, protocols and ports.
>>> Henceforth, I would surmise that the bug is related to the network code?
>>>
>>> Justin Madru
>>>
>> Well positive side is you can at least  grab youre news and info.
>> bad side is you can't access igoogle(or whatever it's called).
>>
>> Domains, protocols and ports must match.
>> probably the culprit(if you found the correct location
>> that's causing this);
>>
>> regards;
>>
>> Justin P. Mattock
>>
> Ok, finally bisected the bug, but the commit isn't related to networking!
> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
> on current git and that fixed the bug.
> 
> By the way, how do I undo my git revert, so I'm back to a pristine tree?
> I want to drop my changes - the revert.
> Also how do I find the commit that merged/pulled in this commit?
> 
> commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Date:   Fri Dec 5 17:17:09 2008 -0800
> 
>     x86: signal: change type of paramter for sys_rt_sigreturn()
> 
>     Impact: cleanup on 32-bit
> 
>     Peter pointed this parameter can be changed.
> 
>     Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Hi,
thanks for reporting.

I'm not sure why this commit affects.
Can you check vmlinux? size, objdump, etc.
On my environment, the generated code looks same.

Thanks,
Hiroshi
