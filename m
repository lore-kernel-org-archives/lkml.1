Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbYKMPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbYKMPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKMPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:32:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:32836 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751066AbYKMPcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:32:41 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+PMswS7aGPjhiCAErJki0H+XQs5/WrTan7V/Um1G
	XyxdkC/4kkNw97
Message-ID: <491C488E.8030609@gmx.de>
Date: Thu, 13 Nov 2008 16:32:30 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       vda.linux@googlemail.com, hugh@veritas.com,
       torvalds@linux-foundation.org, jer@gentoo.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Who broke cb8f488c33 patch? (was Re: [PATCH 1/1] USBHID: correct
 start/stop cycle)
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>	<200811022024.31528.vda.linux@googlemail.com>	<alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz>	<200811120124.41222.vda.linux@googlemail.com>	<alpine.LNX.1.10.0811120126320.24889@jikos.suse.cz> <20081111165038.fb1f2f45.akpm@linux-foundation.org> <491AA08D.9080401@gmail.com>
In-Reply-To: <491AA08D.9080401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 11/12/2008 01:50 AM, Andrew Morton wrote:
>>>> let's fix it for good.
>>>> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
>>>> --- linux-2.6.28-rc4/mm/mmap.c	Mon Nov 10 01:36:15 2008
>>>> +++ linux-2.6.28-rc4.fix/mm/mmap.c	Wed Nov 12 01:21:39 2008
>>>> @@ -1704,7 +1704,7 @@
>>>>  	vma = find_vma_prev(mm, addr, &prev);
>>>>  	if (vma && (vma->vm_start <= addr))
>>>>  		return vma;
>>>> -	if (expand_stack(prev, addr))
>>>> +	if (!prev || expand_stack(prev, addr))
>>>>  		return NULL;
>>>>  	if (prev->vm_flags & VM_LOCKED) {
>>>>  		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
>> It looks like this was caused by me fixing rejects.  That was the fancy
>> include-lots-of-context-so-it-wont-apply patch.
> 
> Great, this one got fixed. Helge, did you proceed with bisecting which another
> commit breaks parics while having this one applied?

I bisected twice. Both times I found this one to be the culprit.
Nevertheless, just reverting this (Thanks Denys!) didn't fixed the USB 
problem.
I'll retry another bisecting round with -rc4 now, but I have the dumb 
feeling the problem is not the USB part, but more in the usbhid driver.
Let's see.

Helge
