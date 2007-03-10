Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXCJKyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXCJKyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXCJKyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:54:04 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:25377 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXCJKyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:54:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dOmr0iX4dt0FpNuyQnrtOfZc5+5FoDR2iVRIOCbrpQffO0qCLa0/6mXTrmgjtcudYXmcRt6kUN484YMvHryb2AtSgUcO0/C1cPA8vw/tKqfkj4cUDstIYwzBQWFdUMso4CNOqsGXXTtE3TUmk2kpwhfjDz8cCqMz69fkp83CMt4=
Message-ID: <1b2aacd80703100254w35c3420co5318541d336e1708@mail.gmail.com>
Date: Sat, 10 Mar 2007 02:54:00 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: "Sergey Vlasov" <vsu@altlinux.ru>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "Parav K Pandit" <parav_pandit@mindtree.com>,
       "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
In-Reply-To: <20070310112203.33c638ee.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no>
	 <fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no>
	 <fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no>
	 <fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no>
	 <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no> <45F0B40F.7070301@shaw.ca>
	 <1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
	 <2C15D00D262B7245B1D8D1799F04D88F04A58C42@mtw01ex01.mindtree.com>
	 <1b2aacd80703091610h9b5bc0ep1b5b58c53ca58e86@mail.gmail.com>
	 <20070310112203.33c638ee.vsu@altlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/07, Sergey Vlasov <vsu@altlinux.ru> wrote:
> On Fri, 9 Mar 2007 16:10:29 -0800 Luong Ngo wrote:
>
> > Thanks Parav, adding singal_allow(SIGALRM) wakeup the blocking
> > interruptible_sleep_on and checking the signal_pending would return
> > true now.
>
> This means that there is also a bug in your userspace program -
> somehow when it invokes ioctl(), it has SIGALRM blocked.  Use
> sigprocmask() (or pthread_sigmask() if your program is multithreaded)
> to ensure that SIGALRM is not blocked when you are expecting it to be
> processed.  (Even if your program does not block SIGALRM, it may
> inherit a blocked SIGALRM from another program which have started it,
> so the safest way is to unblock SIGALRM explicitly.)
>
When creating the thread, which would make ioctl call, the parent
thread does not call any sigprocmask so I assume that means none of
the signals is masked. Hence SIGALRM should be received by the thread.
But this did not happen until I call allow_signal explicitly in the
ioctl handler of the driver. I did not call sigprocmask with
SIG_BLOCK.

> Using allow_signal() is needed only if you create a kernel thread and
> want that thread to handle signals.
>
Could the execution of ioctl in the driver be done in a kernel thread
that created to handle the user ioctl request and therefore it needs
allow_signal?


Thanks a lot,
LNgo
