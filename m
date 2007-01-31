Return-Path: <linux-kernel-owner+w=401wt.eu-S1030453AbXAaRip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453AbXAaRip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXAaRio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:38:44 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43799 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030447AbXAaRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:38:44 -0500
In-Reply-To: <1170209044.26655.364.camel@localhost.localdomain>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 09:38:11 -0800
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> - We would now have some measure of task_struct concurrency.  Read  
>> that twice,
>> it's scary.

> That's the one scaring me in fact ... Maybe it will end up being an  
> easy
> one but I don't feel too comfortable...

Indeed, that was my first reaction too.  I dismissed the idea for a  
good six months after initially realizing that it implied sharing  
journal_info, etc.

But when I finally sat down and started digging through the  
task_struct members and, after quickly dismissing involuntary  
preemption of the fibrils, it didn't seem so bad.  I haven't done an  
exhaustive audit yet (and I won't advocate merging until I have) but  
I haven't seen any train wrecks.

> we didn't create fibril-like
> things for threads, instead, we share PIDs between tasks. I wonder if
> the sane approach would be to actually create task structs (or have a
> pool of them pre-created sitting there for performances) and add a way
> to share the necessary bits so that syscalls can be run on those
> spin-offs.

Maybe, if it comes to that.  I have some hopes that sharing by  
default and explicitly marking the bits that we shouldn't share will  
be good enough.

- z
