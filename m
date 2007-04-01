Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXDASmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXDASmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbXDASmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:42:36 -0400
Received: from mtaout4.012.net.il ([84.95.2.10]:29003 "EHLO mtaout4.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933832AbXDASmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:42:35 -0400
Date: Sun, 01 Apr 2007 21:42:23 +0300
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [patch 13/13] signal/timer/event fds v9 - KAIO eventfd support
 example ...
In-reply-to: <Pine.LNX.4.64.0704011000470.26331@alien.or.mcafeemobile.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Message-id: <460FFD0F.7080107@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 01 Apr 2007 21:42:23 +0300 (IDT)
References: <send-serie.davidel@xmailserver.org.16816.1175371778.13>
 <460FCA90.4000003@argo.co.il>
 <Pine.LNX.4.64.0704011000470.26331@alien.or.mcafeemobile.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Sun, 1 Apr 2007, Avi Kivity wrote:
>
>   
>> What is the motivation for adding aio_resfd to an individual iocb instead of
>> the entire io context?  It seems redundant, as you can already create multiple
>> io contexts to wait on.
>>     
>
> To add it to the context, you need to either change the context create API 
> (I think no-go here), or add a new syscall just to handle that.
> Doing it in the iocb gives finer grained setup, but can be more work for 
> the user that wants to use it for all the iocbs.
>   

I think it's a bit too fine grained, and a new system call 
(io_bindfd()?) would be easier to use.  In addition, you would move the 
eventfd_fget() out of the submission path.

For the users that want fine grained control, they can already call 
io_setup() multiple times and submit iocbs to different completion rings.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

