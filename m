Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbXEHUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbXEHUeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXEHUdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:33:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:23856 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318AbXEHUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F3zxfkgW/4KLnkV+nnW4anekWe0EC6W8r9bCoyG6BJ4fu0TwsTmubg2TIC6CI1irvNeK33Gzmze20su21POAIrSrjg5SGXtPUmfKwXE7A+SrEsXO5c2pUweF7Ppzy2tfPx0QAd5O9LG7447CPTjly04+CmBkT8TUZTiPyauFr2c=
Message-ID: <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com>
Date: Tue, 8 May 2007 13:33:52 -0700
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rogier Wolff" <R.E.Wolff@bitwizard.nl>
Subject: Re: nbd problem.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070508194053.GA23615@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070508194053.GA23615@bitwizard.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
>
> Hi,
>
> The nbd client still reliably hangs when I use it.
>
> While looking into this, I found:
>
>
> 446                 req->errors = 0;
> 447                 spin_unlock_irq(q->queue_lock);
>                    ^^^^^^^^^^^^^^^^^^^^

BTW (this could be unrelated to the original issue here), but can
anybody ever have a _genuine_ excuse to use spin_lock_irq /
spin_unlock_irq and not spin_lock_irqsave / spin_unlock_restore? I
find the latter primitives more tasteful even when I *know* something
is being called with interrupts enabled / disabled -- you never know
when some code is re-used again somewhere else and/or ripped out of
one place and put inside another ... the former API only invites
trouble, if anything.
