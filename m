Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXINXAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXINXAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXINXAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:00:04 -0400
Received: from zakalwe.fi ([80.83.5.154]:53404 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443AbXINXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:00:01 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 19:00:00 EDT
Date: Sat, 15 Sep 2007 01:40:00 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: On thread scheduling
Message-ID: <20070914224000.GI3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consider a simple embedded system:

void interrupt_handler(void)
{
	...
}

int main(void)
{
	...
}

I would like to "emulate" this system with a workstation to make 
development faster. I would create two threads, one executing the 
main() function, and the other occasionally calling interrupt_handler(). 
Before interrupt_handler() is called, the main() thread should be 
stopped asynchronously.

I looked into pthreads documentation and found only pthread_kill(thread, 
SIGTSTP) to do asynchronous stop, but then I also have to play terminal 
tricks to avoid problems..

Is there are function to just disable scheduling of a single thread 
without having other side-effects (such as terminal stuff)? Functions 
like pthread_disable_scheduling(thread) and 
pthread_enable_scheduling(thread) would be good for this..

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
