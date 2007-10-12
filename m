Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXJLCnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXJLCnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXJLCnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:43:06 -0400
Received: from smtpoutm.mac.com ([17.148.16.70]:53313 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXJLCnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:43:05 -0400
In-Reply-To: <200710120002.37341.a1426z@gawab.com>
References: <200710120002.37341.a1426z@gawab.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <46B8DC5E-CD66-40B3-BF82-05259F9D7288@mac.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>, g@0xff.cl,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Reserve N process to root
Date: Thu, 11 Oct 2007 22:42:57 -0400
To: Al Boldi <a1426z@gawab.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't trim CC lists

On Oct 11, 2007, at 17:02:37, Al Boldi wrote:
> David Newall wrote:
>> Valdis.Kletnieks@vt.edu wrote:
>>> What David meant was that "root will always have a slot" doesn't  
>>> *actually* help unless you *also* have a way to actually *spawn*  
>>> such a process.  In order to do the ps, kill, and so on that you  
>>> need to recover, you need to already have either a root shell  
>>> available, or a way to *get* a root shell that doesn't rely on a  
>>> non-root process (so /bin/su doesn't help here).
>>
>> That's right, although it's worse than that.  You need to have a  
>> process with CAP_SYS_ADMIN.  If root processes normally have that  
>> capability then the reserved slots may well disappear before you  
>> notice a problem.  If root processes normally don't have it, then  
>> you need to guarantee that one is already running.
>
> I once posted a patch to handle this DoS, but, as usual, it wasn't  
> accepted.  Go figure...

This isn't really necessary any more with the new CFS scheduler.  If  
you want to prevent excess memory usage then you limit memory usage,  
not process count, so just set the system max process count to  
something absurdly high and leave the user counts down at the maximum  
a user might run.  Then as long as the sum of the user processes is  
less than the max number of processes (which you just set absurdly  
high or unlimited), you may still log in.  With the per-user  
scheduling enabled CFS allows you to run an optimistically-real-time  
game as one user and several thousand busy-loops as another user and  
get almost picture perfect 50% CPU distribution between the users.   
To me that seems a much better DoS-prevention system than limits  
which don't scale based on how many people are requesting resources.

Cheers,
Kyle Moffett

