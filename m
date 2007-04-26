Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbXDZVZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbXDZVZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXDZVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:24:59 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:60266 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755133AbXDZVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:24:58 -0400
Date: Thu, 26 Apr 2007 13:49:02 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: nigel@nigel.suspend2.net, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>,
       Dumitru Ciobarcianu <Dumitru.Ciobarcianu@ines.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
  hang in atomic copy)
In-Reply-To: <200704262237.32665.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704261342540.9674@qynat.qvtvafvgr.pbz>
References: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi> 
 <200704262128.31547.rjw@sisk.pl>  <1177618612.4737.50.camel@nigel.suspend2.net>
 <200704262237.32665.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Rafael J. Wysocki wrote:

>> The general scheme has been working for four or five years - if there
>> was a fundamental issue, we would have found it by now.
>>
>> The scheme isn't complicated.
>
> Conceptually, it is complicated just because you're using the LRU.

I know that I've seen many projects that are working on or claim to have 
suceeded in being able to do live migration of processes from one system to 
another. has anyone looked at useing any of these mechanisms for snapshoting the 
user processes for the std situation? if you can do this a process at a time you 
may be able to avoid the massive blob of a write

instead of what linus was saying

buff = snapshot()
write(buff)

it would be
start_snapshot()   /* stops all userspace schedulers except for this process */
foreach(pid) {
   buff = snapshotpid(pid)
   write(buff)
}

David Lang
