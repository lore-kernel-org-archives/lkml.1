Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYJaAvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYJaAvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYJaAvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:51:40 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36498 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYJaAvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:51:40 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=uCZz8LgpRzh-NFZCcJ8A:9 a=1gbMsf1DOTnKSlSaGr4A:7 a=ooGSfpXWzq_QcP3SRtQelFQr6X0A:4
Message-ID: <490A5698.4080302@shaw.ca>
Date: Thu, 30 Oct 2008 18:51:36 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: James Renton <jrenton@castel.com>
CC: linux-kernel@vger.kernel.org, Joe Maldonado <jmaldonado@castel.com>
Subject: Re: sigqueue() losing signals
References: <fa.mqI1CnLbqkcTn2yfwoMcj8Ca54c@ifi.uio.no>
In-Reply-To: <fa.mqI1CnLbqkcTn2yfwoMcj8Ca54c@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Renton wrote:
> I needed to kick off a bunch of background threads and receive
> notification if one failed due to fatal error.  I was hoping waitpid()
> would work; but found out quickly that although each thread has a pid_t;
> threads and processes were not interchangeable.  Without a timed
> pthread_join() over multiple threads (like WIN32
> WaitForMultipleObjects), I formulated a seemingly dead simple
> implementation using signals.  I hacked out a quick prototype to ensure
> I could get the signals to work as desired.  
> 
> When I ran the prototype, I experienced behavior looking very bug-like;
> but I wanted to post it here in case I am misunderstanding unix signals
> and just doing something silly.  I am requesting for comments or
> [hopefully clever] suggestions... Code follows:

For normal signals, you're not guaranteed that the signal handler will 
be called once for every time the signal is raised. You may get only one 
signal handler call for multiple events if they happen in rapid 
succession. Maybe if you use realtime signals it will work. But this 
seems like a bizarre way to accomplish the task.. better to just set 
some pthread condition in your threads when they exit and do a 
pthread_cond_timedwait on that condition in the main thread.

IMHO, in general, when signals are the answer, chances are the question 
is wrong..

