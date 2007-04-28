Return-Path: <linux-kernel-owner+w=401wt.eu-S1030837AbXD1B3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837AbXD1B3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXD1B3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:29:54 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:60328 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1030837AbXD1B3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:29:53 -0400
Date: Fri, 27 Apr 2007 17:54:20 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.63.0704271751240.10565@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280145.26253.rjw@sisk.pl><alpine.LFD.0.98.0704271647340.9964@woody.l
 inux-foundation.org><200704280300.22604.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Linus Torvalds wrote:

> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
>>
>>> It's doubly bad, because that idiocy has also infected s2ram. Again,
>>> another thing that really makes no sense at all - and we do it not just
>>> for snapshotting, but for s2ram too. Can you tell me *why*?
>>
>> Why we freeze tasks at all or why we freeze kernel threads?
>
> In many ways, "at all".
>
> I _do_ realize the IO request queue issues, and that we cannot actually do
> s2ram with some devices in the middle of a DMA. So we want to be able to
> avoid *that*, there's no question about that. And I suspect that stopping
> user threads and then waiting for a sync is practically one of the easier
> ways to do so.
>
> So in practice, the "at all" may become a "why freeze kernel threads?" and
> freezing user threads I don't find really objectionable.

there was a thread last week (or so) about splitting up the process list, one 
list for normal user processes, one for kernel threads, and one for dead 
processes waiting to be reaped.

it almost sounds like what you want to do is to act as if the normal user 
threads weren't there for a short time (while you make the snapshot) and then 
recover them to continue and save the snapshot.

David Lang
