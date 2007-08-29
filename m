Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXH2XzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXH2XzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXH2XzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:55:12 -0400
Received: from smtpout.mac.com ([17.250.248.172]:58040 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXH2XzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:55:10 -0400
In-Reply-To: <46D5FAE5.3020401@redhat.com>
References: <46D5F462.9010401@redhat.com> <9a8748490708291553j4c21bdf0ueae0b51c99c8190a@mail.gmail.com> <46D5FAE5.3020401@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0C35E890-6F24-4073-9D29-A7D365DCB136@mac.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Date: Wed, 29 Aug 2007 19:55:04 -0400
To: Eric Sandeen <sandeen@redhat.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 29, 2007, at 19:01:57, Eric Sandeen wrote:
> Jesper Juhl wrote:
>> A first step could be to allocate those two char arrays with  
>> kmalloc() instead of on the stack, but then I guess that dump_stack 
>> () gets called from places where we may not really want to be  
>> calling kmalloc(). I guess we could allocate the buffers earlier  
>> (like at boot time) and store pointers somewhere where dump stack  
>> can get to them later when it needs them.
>
> Yep, I thought about something like that... and I assume you'd need  
> a bit of locking around them too.

How about turning off preemption and using a per-CPU buffer?   
Alternatively you could turn off IRQs, poke a per-CPU value to clue  
in any incoming NMIs, and switch to a separate stack.  I suppose if  
you wanted it to work with all of 16 bytes of stack left on both  
thread and IRQ stacks, you could have separate per-CPU NMI stacks;  
the stack-dump would be poking a special per-CPU value and sending  
ourselves an NMI.

There are probably a half dozen other variants on ways to run  
screaming to the CPU saying "It hurts mommy!" and get a new stack in  
which we can play for a while.

Cheers,
Kyle Moffett
