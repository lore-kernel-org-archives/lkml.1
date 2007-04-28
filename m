Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXD1TVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXD1TVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXD1TUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:20:43 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:44585 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1031176AbXD1TUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:20:20 -0400
Date: Sat, 28 Apr 2007 11:44:25 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
In-Reply-To: <200704282114.49815.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704281143440.11638@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <20070428085000.GA3293@elf.ucw.cz>  <Pine.LNX.4.63.0704281130200.11638@qynat.qvtvafvgr.pbz>
 <200704282114.49815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:

> On Saturday, 28 April 2007 20:32, David Lang wrote:
>> On Sat, 28 Apr 2007, Pavel Machek wrote:
>>
>>>>
>>>> We freeze user space processes for the reasons that you have quoted above.
>>>>
>>>> Why we freeze kernel threads in there too is a good question, but not for me to
>>>> answer.  I don't know.  Pavel should know, I think.
>>>
>>> We do not want kernel threads running:
>>>
>>> a) they may hold some locks and deadlock suspend
>>>
>>> b) they may do some writes to disk, leading to corruption
>>>
>>> We could solve a) by carefully auditing suspend lock usage to make
>>> sure deadlocks are impossible even with kernel threads running.
>>
>> remember that we are doing suspend-to-disk, after we do the snapshot we will be
>> doing a shutdown. that should simplify the locking issues
>
> That's assuming that we won't need to cancel the hibernation.

true, but if we cancel the hibernation then why are the locks an issue? they are 
appropriate for the system state.

David Lang
