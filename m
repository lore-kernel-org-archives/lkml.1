Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXD0WsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXD0WsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXD0WsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:48:09 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:63975 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757510AbXD0WsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:48:08 -0400
Date: Fri, 27 Apr 2007 15:12:10 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704272326.58964.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.63.0704271451180.10565@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <20070427124932.GA23513@elf.ucw.cz> <200704272326.58964.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:

> On Friday, 27 April 2007 14:49, Pavel Machek wrote:
>>
>> I think this is very similar to current uswsusp design; except that we
>> are using read on /dev/snapshot to read the snapshot (not memory
>> mapping) and that we freeze the system
>
> Yes, it seems so.
>
>> (because I do not think killall _SIGSTOP is enough).
>

remember, this is being done inside the kernel. the kernel can do things like 
saving off the scheduler queue to prevent any userspace from running during the 
snapshot, it could then move selected pids over to a new queue to selectivly 
'unfreeze' whatever you need (like the X processes for example) and then proceed 
normally (allowing processes to be spawned, forked, etc without activiating the 
rest of userspace becouse the rest just won't be available to be scheduled) and 
userspace can tell the kernel the list of pids to unfreeze so the kernel doesn't 
need to try and guess.

David Lang
