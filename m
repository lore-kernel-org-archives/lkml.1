Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXEFXPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXEFXPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXEFXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:15:04 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4215 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXEFXPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uK+VVfNT8oD4Zzl6FzsHY7PIsZXLJOob1b++UTExf8frwja8pSV/4Ebw56ywCecVcraP+yQVFE4ZZdgMHHwhmDcaI9yuHTsHsJyFx4mOk54ZQfeFSDxcEtslwLbgxYJk2g6LriIB6XUnFaanxigFoXe0j0wA2dOzXOtDWS8TyJY=
Message-ID: <2c0942db0705061615i1c6147a1h6aca54012c3509aa@mail.gmail.com>
Date: Sun, 6 May 2007 16:15:00 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] make hci_notifier a blocking notifier (was Re: BUG: sleeping function called from invalid context at net/core/sock.c:1523)
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Max Krasnyansky" <maxk@qualcomm.com>, marcel@holtmann.org,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705060816v59c1ae70m1d5067fcaba5a25d@mail.gmail.com>
	 <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
X-Google-Sender-Auth: fa430e3155a3d133
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 6 May 2007, Satyam Sharma wrote:
>
> > Anyway, the hci_notifier is called from the following six call sites:
> >
> > hci_dev_open() and hci_dev_close() -> both called from
> > hci_sock_ioctl() => both can sleep
> > hci_register_dev() and hci_unregister_dev() => again both are capable
> > of sleeping
> > hci_suspend_dev() and hci_resume_dev() -> called from the .suspend()
> > and .resume() of the hci_usb_driver, and again both of these can sleep
> >
> > Is there any other reason why hci_notifier must be an atomic notifier?
> >
> > (CC'ing Alan Stern just in case, apparently hci_notifier became atomic
> > when notifier chains were classified into atomic / blocking)
>
> I don't remember exactly why this particular choice was made.  Perhaps we
> found that the notifier callout routines didn't use any blocking
> primitives (we may have been mistaken about this -- there was a lot of
> code to check) and so therefore the choice didn't matter.  In that case we
> probably just decided to make it an atomic notifier to keep things simple.
>
> As you found, changing it to a blocking notifier is very easy.  Provided
> all the callers are non-atomic it should work just fine.

Okay, I'll go ahead and try the patch, then, and report back.

Thanks,

Ray
