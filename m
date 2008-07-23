Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYGWUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYGWUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGWUjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:39:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:58856 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYGWUjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s9RSbBKxC/CkWpf1zv/js5eifv11hJm4aCkqR7RowPxiZWuebHyNh4BGTjPAsqzG39
         TwYpd+fFqBoP5U20Gr+I3Uj4k1utaArr3VR4HRs6mtuPuWPtp8zVboB03TliaOi8kH4K
         Ddl2aWdDgryja1F39pI0nF+t52MMXKSbUN7U4=
Message-ID: <19f34abd0807231339i4ba524d6u27f1c4054197a81@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:39:22 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080723203109.GH14380@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <20080723203109.GH14380@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Jul 23, 2008 at 10:31 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Wed, Jul 23, 2008 at 01:07:04PM -0700, Vegard Nossum wrote:
>> Hi,
>>
>> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
>> yesterday):
>
> Do you see this in 2.6.26 aswell? I suspect it is coming from post 2.6.26
> changes.

Just reproduced it on latest linux-2.6.git.

>> BUG: unable to handle kernel paging request at 00664381
>> IP: [<c010b274>] free_thread_xstate+0x4/0x30
> ...
>

The funny thing is that this number (00664281) is _always_ the same,
even on the newer kernel. What's special about it?

>> EIP is at arch/x86/kernel/process.c:36:
>>
>>         if (tsk->thread.xstate) {
>>
>
> It looks like the kernel stack of that process got corrupted, corrupting the
> task pointer in thread_info. Can you send us your config file?

It has been uploaded here:

http://userweb.kernel.org/~vegard/bugs/20080724-fork/config

Given the reproducible nature of this, I think I'll just go ahead and
start a bisect...

Thanks for looking :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
