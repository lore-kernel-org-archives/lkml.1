Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYEMOKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYEMOKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYEMOK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:10:28 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47706 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbYEMOK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:10:27 -0400
Message-ID: <4829A15A.1070203@bull.net>
Date: Tue, 13 May 2008 16:10:34 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 0/9] Scalability requirements for sysv ipc - v3
References: <20080507113553.395937000@bull.net> <2f11576a0805070619x11c462fdpbee1b652a83d7071@mail.gmail.com>
In-Reply-To: <2f11576a0805070619x11c462fdpbee1b652a83d7071@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
> nice improvement.
> but...
> 
> 
>>   2.6.25-rc3-mm1   2.6.25-rc3-mm1+   2.6.25-mm1   Patched 2.6.25-mm1
>> 1         1168441           1064021       876000               947488
>> 2         1094264            921059      1549592              1730685
>> 3         2082520           1738165      1694370              2324880
>> 4         2079929           1695521       404553              2400408
>> 5         2898758            406566       391283              3246580
>> 6         2921417            261275       263249              3752148
>> 7         3308761            126056       191742              4243142
>> 8         3329456            100129       141722              4275780
>>
>> 1st column: stock 2.6.25-rc3-mm1
>> 2nd column: 2.6.25-rc3-mm1 + ipc patches (store ipcs into idrs)
>> 3nd column: stock 2.6.25-mm1
>> 4th column: 2.6.25-mm1 + this pacth series.
> 
> 
> this result is slightly odd.
> 
> similar to 2.6.25-rc3-mm1 and patched-2.6.25-mm1
> similar to 2.6.25-mm1 and 2.6.25-rc3-mm1
> 
> but
> 
> not similar to 2.6.25-rc3-mm1 and patched-2.6.25-rc3-mm1
> not similar to 2.6.25-mm1 and patched-2.6.25-mm1
> 
> Is patched-2.6.25-rc3-mm1 and patched-2.6.25-mm1 applied the same patch?

No

> or I misunderstand how to see your chart?
> 
> 

Well, looks like the description was not clear, sorry for that!
1st column: 2.6.25-rc3-mm1 with original ipc implementation
                            (i.e. ipcs stored in an array)
2nd column: 2.6.25-rc3-mm1, with ipcs stored in an idr tree
             actually, that's when the performance regression
             had been introduced.
3rd column: 2.6.25-mm1, still with the same implementation
             i.e. still with degraded performances.
4th column: 2.6.25-mm1 + rcu-based implementation of the idr,
             which is the current patch series.

Hope this makes things more clear.

Regards,
Nadia
