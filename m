Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbXIPHR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbXIPHR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 03:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXIPHRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 03:17:19 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:55172 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXIPHRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 03:17:18 -0400
In-Reply-To: <20070914224000.GI3400@zakalwe.fi>
References: <20070914224000.GI3400@zakalwe.fi>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E1A87DCE-4438-45B8-87CB-8BB55C9F4149@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: On thread scheduling
Date: Sun, 16 Sep 2007 03:16:52 -0400
To: Heikki Orsila <shdl@zakalwe.fi>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 14, 2007, at 18:40:00, Heikki Orsila wrote:
> Consider a simple embedded system:
>
> void interrupt_handler(void)
> int main(void)
>
> I would like to "emulate" this system with a workstation to make  
> development faster. I would create two threads, one executing the  
> main() function, and the other occasionally calling  
> interrupt_handler().  Before interrupt_handler() is called, the main 
> () thread should be stopped asynchronously.

Actually you probably just want to do this with an ordinary single- 
threaded program.  Just do your main() thing normally and schedule a  
signal-based timer at program start (or whenever you actually set up  
your periodic interrupt source);  the timer signal-handler will act  
as the interrupt handler.  Alternatively you could have 2 threads  
where the *only* thing the second thread does is a timed poll() loop  
on an FD where it reads commands from the main thread.  When the main  
thread wants to change the interval-between-interrupts or some other  
interrupt configuration it writes the info down the FD to the  
alternate thread which actually sets up the change.  The main program  
then continues running and periodically receives its SIGUSR1 or  
whatever from the other thread and uses that as the interrupt.

Cheers,
Kyle Moffett

