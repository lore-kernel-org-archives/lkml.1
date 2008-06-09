Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYFIJE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYFIJE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYFIJEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:04:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:43614 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbYFIJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:03:59 -0400
Message-ID: <484CF1FB.804@aitel.hist.no>
Date: Mon, 09 Jun 2008 11:03:55 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Jakub Jozwicki <jozwicki@aster.pl>
CC: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sched_yield() on 2.6.25
References: <fa.5iKTy3xTJkKWZLGio+GIHXi3+0o@ifi.uio.no> <484C588A.9090800@shaw.ca> <200806090837.25121.jozwicki@aster.pl>
In-Reply-To: <200806090837.25121.jozwicki@aster.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jozwicki wrote:
> From the man sched_yield:
>
> A  process  can  relinquish  the  processor  voluntarily without blocking by
> calling sched_yield().  The process will then be moved to the  end  of  the 
> queue  for  its static priority and a new process gets to run.
>
> and also IEEE/Open Group:
> http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html
>
>   
>>> 	pthread_mutex_lock(&mutex);
>>> 	th = pthread_self();
>>> 	if (pthread_equal(th,last_th)) {
>>> 	    pthread_mutex_unlock(&mutex);
>>> 	    sched_yield();
>>> 	    continue;
>>>       
>
> Here with SCHED_OTHER sched_yield for the first 100-200 times does nothing.
> Should the man be updated?
>   
Having the man page mention the fact that that sched_yield() probably
won't do "what  you intend"  in the non-realtime cases is probably a 
good idea;
that way we get fewer application programmers who mistakenly think
that sched_yield can be used for their purposes. And then we'll have
less broken apps. 

A pointer to info about what they might want to use instead is even better.

Helge Hafting

