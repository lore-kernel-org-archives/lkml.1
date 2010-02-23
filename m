Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0BWOAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 09:00:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43392 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0BWOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 09:00:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B83DF4A.9020502@s5r6.in-berlin.de>
Date: Tue, 23 Feb 2010 14:59:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: viresh kumar <viresh.linux@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: QUERY: Inclusion of header files in kernel header files
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com> <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com> <20100223065953.GB32503@liondog.tnic> <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com> <20100223095025.GA18559@liondog.tnic> <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com> <20100223130128.GB30382@aftab>
In-Reply-To: <20100223130128.GB30382@aftab>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> From: viresh kumar <viresh.linux@gmail.com>
>> Actually this issue is not present only in bus.h, but some other
>> kernel header files.
>> Like: arch/arm/include/asm/clkdev.h don't include list.h file but
>> using struct list_head
>>
>> May be we need to check this in other header files also.
> 
> Well, you should talk to the arm maintainer about that task and whether
> it is desirable.

I agree but feel compelled to add:  While each header file should indeed
include everything that is necessary to allow for arbitrary orders of
inclusion of this header,¹ this is sometimes not possible for core
kernel headers or architecture headers.

An example over which I stumbled a few days ago:  linux/wait.h cannot
easily include linux/sched.h although it uses definitions from it.
There is a direct circular dependency which can be easily resolved, but
there are also dependencies at deeper levels of indirection which cannot
be easily resolved.

----------
¹)  IOW each header should include everything which it uses.  OTOH a
user of that header should not rely on having its own dependencies
included indirectly.
-- 
Stefan Richter
-=====-==-=- --=- =-===
http://arcgraph.de/sr/
