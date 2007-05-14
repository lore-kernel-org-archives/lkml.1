Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbXENP42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbXENP42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbXENP4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:56:17 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:48169 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXENP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m5FDkkso06lbMfDuMsmJdkKx4BatCm6HZeEjYYQNV8tRgZNAYkDX7atQ6Da0UbabNGqbzjG5zneW07aejWflAJ7fGzsFo1V9/BrPHheqVKhbM36hZe9Yp5hfKhXwyG+D4B7XabpdYqhrMIJ9vf6hgknWJMPLSW7lYWU15ypExhw=
Message-ID: <a2ebde260705140856m3917d761xe1067c76fa000b18@mail.gmail.com>
Date: Mon, 14 May 2007 23:56:15 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Bahadir Balban" <bahadir.balban@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "Learning Linux" <learninglinux4@gmail.com>,
       "pradeep singh" <2500.pradeep@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that the reason an interrupt can not sleep is because an
interrupt is not associated with any context. But I do not agree that
it is specifically because the scheduler can not *resume* the context.

In early version, the ISR always borrow the stack of the currently
running process, so if the kernel design had allowed ISR sleep, it
would automatically be able to implement the context switch naturally.
But ISR sleep has been forbidden from the very beginning.

The reason why kernel design does not allow ISR sleep is because a
process should not be forced to wait for a event that irrelative to
itself. When an exception handler sleep, the event it sleeps on is
always in some sense related to the process incurring that exception.
But if an ISR was allowed to sleep, the event it sleeps on would have
nothing to do with the process being interrupted.

So my understanding is, the forbidden of ISR sleep is not because of
the difficulty to resume context, but because a process should not
wait for irrelative event.


2007/5/14, Bahadir Balban <bahadir.balban@gmail.com>:
> On 5/14/07, Learning Linux <learninglinux4@gmail.com> wrote:
> > Ok, but how about an ISR, that does not take any locks? Why can't we
> > sleep in SUCH an ISR?
> > LL
> > -
>
> The killer reason why you can't sleep in an interrupt is because an
> interrupt is not associated with any context in the first place. What
> is a context, then? It is the state information for a process. This
> includes the kernel and userspace stack pointers, the register set,
> and the page tables for that process. The scheduler has access to all
> this information, to preempt one process and run another. Contrary to
> this, an interrupt, depending on the version of your kernel and arch,
> uses a separate irq stack or the kernel stack of the interrupted
> process. An irq is not a context but merely a temporary execution to
> be concluded asap.
>
> Hope this helps,
> Bahadir
>
> --
> To unsubscribe from this list: send an email with
> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
> Please read the FAQ at http://kernelnewbies.org/FAQ
>
>
