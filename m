Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbXJLFuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbXJLFuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbXJLFt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:49:56 -0400
Received: from smtpoutm.mac.com ([17.148.16.82]:55351 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757790AbXJLFtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:49:55 -0400
In-Reply-To: <200710120837.23586.a1426z@gawab.com>
References: <200710120002.37341.a1426z@gawab.com> <46B8DC5E-CD66-40B3-BF82-05259F9D7288@mac.com> <200710120837.23586.a1426z@gawab.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4768FB5E-33D1-45B9-AA71-1D979F56B1B1@mac.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>, g@0xff.cl,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Reserve N process to root
Date: Fri, 12 Oct 2007 01:49:50 -0400
To: Al Boldi <a1426z@gawab.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 12, 2007, at 01:37:23, Al Boldi wrote:
> Kyle Moffett wrote:
>> This isn't really necessary any more with the new CFS scheduler.   
>> If you want to prevent excess memory usage then you limit memory  
>> usage, not process count, so just set the system max process count  
>> to something absurdly high and leave the user counts down at the  
>> maximum a user might run.  Then as long as the sum of the user  
>> processes is less than the max number of processes (which you just  
>> set absurdly high or unlimited), you may still log in.  With the  
>> per-user scheduling enabled CFS allows you to run an  
>> optimistically-real-time game as one user and several thousand  
>> busy-loops as another user and get almost picture perfect 50% CPU  
>> distribution between the users. To me that seems a much better DoS- 
>> prevention system than limits which don't scale based on how many  
>> people are requesting resources.
>
> You have a point, and resource-controllers can probably control DoS  
> a lot better, but the they also incur more overhead.  Think of this  
> "lockout prevention" patch as a near zero overhead safety valve.

But why do you need to add "lockout prevention" if it already  
exists?  With CFS' extremely efficient per-user-scheduling (hopefully  
soon to be the default) there are only two forms of lockout by non- 
root processes:  (1) Running out of PIDs in the box's PID-space  
(think tens or hundreds of thousands of processes), or (2) Swap- 
storming the box to death.  To put it bluntly trying to reserve free  
PID slots is attacking the wrong end of the problem and your so  
called "lockout prevention" could very easily ensure that 10 PIDs are  
available even if the user has swapstormed the box with the PIDs he  
does have.

Cheers,
Kyle Moffett
