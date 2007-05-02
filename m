Return-Path: <linux-kernel-owner+w=401wt.eu-S2992918AbXEBIpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992918AbXEBIpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992916AbXEBIpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:45:41 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35663 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992911AbXEBIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:45:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=wMrgE6LKpWMCZmI5XjxqlOe+//OrRkeUkAey6BCnCc9CqHHn3r6bAONp3Uteq6CEHfzsP3DRSlZousvifGuD9klpXqvaS7QJnaGqY2UJnzBe1ajS9tVnTToL4b1SLKoH42dFfegX5FCBrQxAoJyApaEI03vY7E+F/o4zvkeESuU=  ;
X-YMail-OSG: JXy7QcYVM1moYoW2Oi2AREeA8zbcYmE._fiLgPi_JIuw1nbRiXQzea04JyUWI2HVJoUwhwQpaQ--
Message-ID: <46384FAE.8030606@yahoo.com.au>
Date: Wed, 02 May 2007 18:45:34 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bhuvan Kumar MITTAL <bhuvan.mittal@st.com>
CC: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "'Daniel J Blueman'" <daniel.blueman@gmail.com>
Subject: Re: How to make mmap'ed kernel buffer non-cacheable
References: <04b101c78c93$1e234ea0$142ec70a@dlh.st.com>
In-Reply-To: <04b101c78c93$1e234ea0$142ec70a@dlh.st.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You can do down_interruptible to make the down interruptible.

Bhuvan Kumar MITTAL wrote:
> I'll rephrase the problem as follow:
> 
> I have a userthread which makes ioctl calls to the kernel and once it reaches inside the kernel it waits on a semaphore. It then does some work inside the kernel and continuously keeps looping between the kernel and user space in an endless while loop. 
> 
> I want to kill that thread from another user thread while the former is waiting on a semaphore in kernel (which it will never get) coz I want a clean exit of my driver. Please suggest me a way. I did try the use of pthread_cancel, but that is possible only if the target thread is executing in user space and making use of a pthread_testcancel call (with cancelability enabled ofcourse). 
> 
> Kindly suggest something. 
> 
> 
>>In continuation to this, I have another query:
>>As mentioned above, If there is a kernel task waiting on a semaphore (maybe even in hung state) and I wish to kill the kernel task from user space by making an ioctl call into the kernel, then how is it possible? Is it feasible at all?
> 
> 
> If the kernel task is hung because of some bug in your code, then it isn't
> really possible in general. You could always just "up" the semaphore and hope,
> but things might be corrupted.
> 
> If you just want to tell the kernel task to quit, I guess you'd just introduce
> some quit ioctl message, and have the kernel thread respond to that.
> 
> 
> 


-- 
SUSE Labs, Novell Inc.
