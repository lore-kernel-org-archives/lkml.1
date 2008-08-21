Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYHUOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYHUOKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYHUOKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:10:31 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36985 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYHUOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:10:31 -0400
Message-ID: <48AD7705.2000404@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 16:09:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: jmerkey@wolfmountaingroup.com, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au>
In-Reply-To: <200808212337.38626.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
>> It's simple to reproduce.  Take away the volatile declaration for the
>> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
>> references and watch the thing lock up in SMP with multiple processors in
>> the debugger each stuck with their own local copy of debug_lock.
> 
> You should disable preempt before getting the processor id. Can't see any
> other possible bugs, but you should be able to see from the disassembly
> pretty easily.

debug_lock() is AFAICS only called from contexts which have preemption
disabled.  Last time around I recommended to Jeff to document this
requirement on the calling context.

But even though preemption is disabled, debug_lock() is still incorrect
as I mentioned in my other post a minute ago.  It corrupts its .flags
and .count members.  (Or maybe it coincidentally doesn't as long as
volatile is around.)
-- 
Stefan Richter
-=====-==--- =--- =-=-=
http://arcgraph.de/sr/
