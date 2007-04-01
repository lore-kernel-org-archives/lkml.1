Return-Path: <linux-kernel-owner+w=401wt.eu-S964888AbXDAULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbXDAULW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXDAULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:11:22 -0400
Received: from mtaout5.012.net.il ([84.95.2.13]:8465 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXDAULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:11:21 -0400
Date: Sun, 01 Apr 2007 23:11:12 +0300
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [patch 13/13] signal/timer/event fds v9 - KAIO eventfd support
 example ...
In-reply-to: <Pine.LNX.4.64.0704011146380.26550@alien.or.mcafeemobile.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Message-id: <461011E0.1020607@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 01 Apr 2007 23:11:12 +0300 (IDT)
References: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
 <460FCA90.4000003@argo.co.il>
 <Pine.LNX.4.64.0704011000470.26331@alien.or.mcafeemobile.com>
 <460FFD0F.7080107@argo.co.il>
 <Pine.LNX.4.64.0704011146380.26550@alien.or.mcafeemobile.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:

  

>> I think it's a bit too fine grained, and a new system call (io_bindfd()?)
>> would be easier to use.  In addition, you would move the eventfd_fget() out of
>> the submission path.
>>     
>
> IMO the cost of the eventfd_fget() (have you seen it?) is not worth adding 
> a new syscall.
>   

There's an atomic op there (and another on the way out).  Probably on a 
busy cacheline.  Still it's probably lost in the noise.

Regardless of that, I think that specifying the fd per submission is 
wrong.  It feels like a setup thing that needs to be done once.  We 
shouldn't skimp on syscalls, especially on something as important as 
unifying the async event model.


> Actually, the flags field that Linus suggested may be given an extra meaning of 
> "bind to ctx", that'd solve the problem w/out new syscalls.
>
>   

I don't see how.  It's still per submission.  You could do it on the 
first iocb, but that's just adding warts to the API.

You could add an IO_CMD_BIND_EVENTFD, but that feels wrong too, as it 
isn't really an I/O command.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

