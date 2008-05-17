Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYEQTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYEQTWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYEQTWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:22:01 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:61122 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755043AbYEQTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:22:00 -0400
Message-ID: <482F30A0.4090203@seznam.cz>
Date: Sat, 17 May 2008 21:23:12 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, rth@twiddle.net,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: Locking API testsuite problem - Microblaze
References: <482E8438.2040201@seznam.cz> <20080517073032.GA2638@parisc-linux.org>
In-Reply-To: <20080517073032.GA2638@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> On Sat, May 17, 2008 at 09:07:36AM +0200, Michal Simek wrote:
>> Hi Richard, Tony, Arnd and others,
>>
>> I turn on API testsuite for Microblaze CPU for stable 2.6.24 and I got nice log
>> with some faults. The same problem I have on latest version.
>>
>> I found the similar problem for alpha CPU and ia64 but I haven't found solving
>> these issues. Could you give me a hint how to solve this problem.
> 
> You missed the crucial line:

oou.

> 143 out of 218 testcases failed, as expected.
> 
> Some of these testcases are /expected/ to fail.  Succeeding would be an
> bug.  There are no bugs here.

Thanks for your help. Are these tescases architecture dependent? Because I saw
some logs from other arch and they have everything OK.

Does it mean that everything what I supported works well?

I look to source code and I found these two lines.

DO_TESTCASE_6("double unlock", double_unlock);
DO_TESTCASE_6("initialize held", init_held);

and macro

#define DO_TESTCASE_6(desc, name)                               \
         print_testname(desc);                                   \
         dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);            \
         dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);         \
         dotest(name##_rlock, FAILURE, LOCKTYPE_RWLOCK);         \
         dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);          \
         dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);           \
         dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);           \
         printk("\n");

My results
                             | spin |wlock |rlock |mutex | wsem | rsem |
                double unlock:  ok  |  ok  |failed|failed|failed|failed|
              initialize held:failed|failed|failed|failed|failed|failed|

Is this result OK? Because macro say that expected value is failed.

Regards,
Michal

