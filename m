Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYIAJRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYIAJRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYIAJQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:16:51 -0400
Received: from il.qumranet.com ([212.179.150.194]:56430 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYIAJQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:16:50 -0400
Message-ID: <48BBB2FF.9040104@qumranet.com>
Date: Mon, 01 Sep 2008 12:16:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [REGRESSION] High, likely incorrect process cpu usage counters
 with kvm and 2.6.2[67]
References: <48BABC19.1060509@qumranet.com> <f7848160808311109v70db1e99hb6af3b89c34d0d8c@mail.gmail.com>
In-Reply-To: <f7848160808311109v70db1e99hb6af3b89c34d0d8c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On Sun, Aug 31, 2008 at 11:43 AM, Avi Kivity <avi@qumranet.com> wrote:
>   
>> Running an idle Windows VM on Linux 2.6.26+ with kvm, one sees high values
>> for the kvm process in top (30%-70% cpu), where one would normally expect
>> 0%-1%.  Surprisingly, the per-cpu system counters show almost 100% idle,
>> leading me to believe this is an accounting error and that the process does
>> not actually consume this much cpu.
>>     
>
> Busted process accounting - This looks the same as
> http://bugzilla.kernel.org/show_bug.cgi?id=11209 .
> Please verify. Peter's patch in latest git stops showing "incorrect
> looking" CPU usage but at least the process times are still wrong,
> horribly.
> In fact the CPU usage thing in -rc5 is likely also incorrect but I
> need to analyze that bit a little more.
>
> From Today's Git -
>
> PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>
> 12961 parag     20   0 83000 8908 6628 R    0  0.1  5124415h npviewer.bin
>
>   

Yes, it looks very similar.  In my tests, %CPU is consistent with TIME; 
it's just not consistent with what's actually happening and with the 
global statistics.


-- 
error compiling committee.c: too many arguments to function

