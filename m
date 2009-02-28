Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZB1Ama@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZB1Ama (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 19:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZB1AmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 19:42:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46585 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbZB1AmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 19:42:21 -0500
Message-ID: <c73ef954d3030022416d249ba8fefe8e.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661fca240cb094bcf4d261ccebab9848.squirrel@webmail-b.css.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
    <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
    <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
    <b0f5e75d938ffb61bdda7c88b962d3fe.squirrel@webmail-b.css.fujitsu.com>
    <b040c32a0902271600h31785bb8q93acde59f5d15e3d@mail.gmail.com>
    <661fca240cb094bcf4d261ccebab9848.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 28 Feb 2009 09:42:17 +0900 (JST)
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Ken Chen" <kenchen@google.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote：
> Ken Chen wrote：
>> On Fri, Feb 27, 2009 at 3:34 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> "a lot of" ? I talking about cpu hotplug and reading another file as
>>> /sys/devices/system/cpu/present every time before reading this file
>>> gives much much much more overhead ;)
>>
>> yes, really a lot.  CPU hotplug is an uncommon event.  It happens
>> perhaps once a day? maybe once an hour?
>>
> Are you saying the software should have hotplug script and send SIGHUP or
> some to reload the present map ?
>
>> User monitoring process usually reads usage_percpu at fairly high
>> rate, say once a sec.  At each pass it will need to parse N number of
>> CPU index.  The overhead is N_CPU * T, where T is time in second
>> between cpu hotplug event.  Assume T = one day, on a moderate sized
>> 64-CPU size machine, the overhead is:
>>
>> 64 * 86400 : 1, that's like 5.5 million to 1 ratio.  To me that is
>> *high* overhead.
>>
> Sounds strange. I can't catch hat you want to say.
>
Ignore above, I caught, at last. I'll add text to documenation.

BTW, current interface to reset cpuacct (write ops) just reset
specified level of cpuacct and will not clear other hierarchical levels.
Doesn't this behavior confuse software ?

Thanks,
-Kame





