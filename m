Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZFGOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZFGOUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZFGOUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:20:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZFGOUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:20:09 -0400
Message-ID: <4A2BCC6F.8090004@redhat.com>
Date: Sun, 07 Jun 2009 10:19:27 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
In-Reply-To: <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Larry,
> 
> On Sun, Jun 7, 2009 at 4:10 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.29.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13319
>>> Subject               : Page allocation failures with b43 and p54usb
>>> Submitter     : Larry Finger <Larry.Finger@lwfinger.net>
>>> Date          : 2009-04-29 21:01 (40 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>>> Handled-By    : Johannes Berg <johannes@sipsolutions.net>
>> This bug is extremely difficult to pin down. I cannot reproduce it at
>> will. The system has to be up for a long time, which is difficult with
>> testing the late RC's of 2.6.30 and the code in wireless-testing so
>> that new bugs don't end up in 2.6.31-RCX. That said, it still was in
>> 2.6.30-RC6 and I'm not aware of any changes since that would fix it.
>>
>> My operating kernel is patched with additional diagnostics to help me
>> understand why a kmalloc request for a buffer of 1390 bytes suddenly
>> ends up as an O(1) request. Unfortunately, I don't have any answers.
> 
> Looking at the out-of-memory trace, there's still memory available but
> the pskb_expand_head() allocation is GFP_ATOMIC so there's not much
> the page allocator can do here. The amount of memory consumed by
> inactive_file is pretty high so maybe the problem is related to the
> recent mm/vmscan.c changes. Lets copy some more mm developers and see
> if they can help out.

That is a very strange trace.  The Mem-Info indicates
that the system has more than enough memory free, and
also enough memory in higher-order free blocks.

This would indicate a bug somewhere in the page
allocator - this memory should have been given to this
allocation request.

-- 
All rights reversed.
