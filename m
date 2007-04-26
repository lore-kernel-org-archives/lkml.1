Return-Path: <linux-kernel-owner+w=401wt.eu-S1031449AbXDZSvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031449AbXDZSvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031450AbXDZSvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:51:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:27084 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031449AbXDZSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TI4q6iz64DcEqn+5nyzj6SufJY49w4QbZbf/8rDb9lNGplgTvDD5pvG/7ikyN7hME+MZm7Ao6G6/qJHpNsUXVpJG/N/R6TICtUf9rEDSkI/szSikZJv8BvTAmuGf0BdFNu05KnSNJYewpKecqu4fsK6jsWsj1GElHTMI3JI8+To=
Message-ID: <a44ae5cd0704261151m99bc14ai18a01d1de5c49184@mail.gmail.com>
Date: Thu, 26 Apr 2007 11:51:22 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: use different lockdep subclass for s_active deactivation
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
In-Reply-To: <4630E26D.2050703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
	 <462EE4B7.6000708@gmail.com> <20070426145047.GF17130@htj.dyndns.org>
	 <a44ae5cd0704261021n78780c71i4c8f7613d58dec54@mail.gmail.com>
	 <4630E26D.2050703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, Tejun Heo <htejun@gmail.com> wrote:
> Miles Lane wrote:
> > On 4/26/07, Tejun Heo <htejun@gmail.com> wrote:
> >> A sysfs node can delete other sysfs files when accessed.  This results
> >> in recursive s_active locking - read lock for file access, down lock
> >> of the vicitim for deactivation.  Tell lockdep that it's okay.
> >>
> >> Signed-off-by: Tejun Heo <htejun@gmail.com>
> >> ---
> >> Miles, please test this patch.  It should remove the lockdep warning.
> >> Fixes for the other two problems will soon follow.
> >>
> >> Greg, Andrew, after all the fixes are verified, I'll merge the fixes
> >> into the original patches and resend all the sysfs updates in better
> >> shape.  Sorry about all the trouble.
> >
> > Should I test this with 2.6.21-rc7-mm2?
> > It doesn't apply cleanly.
> >
> > # patch -p1 -l --dry-run < tejun.patch
> > patching file fs/sysfs/dir.c
> > Hunk #1 succeeded at 31 with fuzz 1 (offset -29 lines).
> > patching file fs/sysfs/sysfs.h
> > Hunk #1 succeeded at 40 (offset -1 lines).
> > Hunk #2 succeeded at 182 with fuzz 1 (offset -1 lines).
>
> It's in the middle of gregkh patch series but you can safely ignore the
> fuzzes.

WIth this patch applied to 2.6.21-rc7-mm2, I am not seeing any of the
problems I reported against 2.6.21-mm1, except for one.  The first
time I tried to suspend from the Gnome Quit dialog, I heard the pop
associated with unloading the sound module, but all the buttons stayed
lit up until I touched the Synaptics mousepad.  Then the machine
entered the suspend state.  Subsequent attempts to suspend worked
without a hitch (no mousepad events required).  Another problem I
noticed is that the lib switch is not triggering a suspend.  I tried
repeatedly.

Thanks,
           Miles
