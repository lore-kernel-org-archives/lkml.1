Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZLBB2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZLBB2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZLBB2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:28:32 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33386 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZLBB2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Tg7pxXre7ad7SGnnRD9qv8MdMyJzAd/m6WtY8RX2vDB3wuh5BMvwjfUk8rFroNVhEp
         ytcuH1ZfF+Zo6HXk79E5oWAC+KkrFI0b1VHm43+wLrsL8OpFrggfSskse8P2ptTWGlyJ
         mZdpXPRKNr598yCefoZHR6HqApf1xQXikJJks=
Subject: Re: General kernel question about waiting for events
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091202002424.1e430662@lxorguk.ukuu.org.uk>
References: <1259712620.23837.22.camel@maxim-laptop>
	 <20091202002424.1e430662@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 03:28:32 +0200
Message-ID: <1259717312.24723.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 00:24 +0000, Alan Cox wrote: 
> > In that case, wrapped in different packages, it always ends with
> > following loop:
> > 
> > while( event == false )
> > schedule();
> 
> No. If it were to do that then real time processes could spin eating the
> CPU forever.
> 
> There is a difference between rescheduling and sleeping for an event.
> Sleeping for an event (ie on a waitqueue) means that you will not be
> woken until the wait queue is woken (or certain other things like signals
> if interruptible). Rescheduling gives the CPU to someone else if anyone
> wants it.
> 
> In short the different task states that are set are the important bit to
> look at to understand this further.
Thanks you very much!

I already begin to investigate in that area, but your answer sums
everything up, sorry for silly (as I expected) question.

So, current task state is set to TASK_UNINTERRUPTIBLE or
TASK_INTERRUPTIBLE which differ in signal delivery (that I understood,
the TASK_INTERRUPTIBLE will break the wait when signal is received) but
both mean that current task is removed from scheduler pool until it is
woken up, or in case of schedule_timeout() also after the timeout
expires.
Also wait_event_interruptible_timeout does check the condition to avoid
useless sleeps, but if another thread or interrupt handler want to wake
it up, it not only sets that condition (it is optional at all) but
actually wakes the task up using literally wake_up() or related
functions.

Best regards,
Maxim Levitsky


