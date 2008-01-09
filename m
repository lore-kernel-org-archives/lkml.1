Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYAIGhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYAIGhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYAIGh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:37:26 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:62823 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbYAIGhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kzk1l/bSt5OJnOPj+TVKO7uGzxLjTSfrcBq1kCRR/yRL4Quz+3kuQUPmibMEfsgAtYYW3UpqoKacWJA2lwkgxrOzbwKRIGbR1dHuNxgybrlDO+siEQtsF2UOLT/e/55q1SYrCW/gAaMI6TZrN/cok1pQFsmLZqigICAE0h+u3Ls=
Message-ID: <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
Date: Wed, 9 Jan 2008 14:37:22 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       James.Bottomley@hansenpartnership.com, dbrownell@users.sourceforge.net,
       linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org,
       cbou@mail.ru, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, krh@redhat.com,
       stern@rowland.harvard.edu, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
In-Reply-To: <20080109061316.GA3249@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	 <200801070101.15168.david-b@pacbell.net>
	 <478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de>
	 <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de>
	 <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	 <20080108224837.GA19623@suse.de>
	 <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	 <20080109061316.GA3249@darkstar.te-china.tietoenator.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 2:13 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Wed, Jan 09, 2008 at 09:32:48AM +0800, Dave Young wrote:
> > On Jan 9, 2008 6:48 AM, Greg KH <gregkh@suse.de> wrote:
> > > On Tue, Jan 08, 2008 at 03:05:10PM +0800, Dave Young wrote:
> > > > On Jan 8, 2008 1:20 AM, Greg KH <gregkh@suse.de> wrote:
> > > > > On Mon, Jan 07, 2008 at 06:13:37PM +0100, Stefan Richter wrote:
> > > > > > It's already in the driver core to the most part.  It remains to be seen
> > > > > > what is less complicated in the end:  Transparent mutex-protected list
> > > > > > accesses provided by driver core (requires the iterator), or all the
> > > > > > necessary locking done by the drivers themselves (requires some more
> > > > > > lock-taking but perhaps fewer lock instances overall in the drivers, and
> > > > > > respective redefinitions and documentation of the driver core API).
> > > > >
> > > > > I favor changing the driver core api and doing this kind of thing there.
> > > > > It keeps the drivers simpler and should hopefully make their lives
> > > > > easier.
> > > >
> > > > What about this?
> > > >
> > > > #define class_for_each_dev(pos, head, member) \
> > > >         for (mutex_lock(&(container_of(head, struct class, devices))->mutex), po
> > > > s = list_entry((head)->next, typeof(*pos), member); \
> > > >         prefetch(pos->member.next), &pos->member != (head) ? 1 : (mutex_unlock(&
> > > > (container_of(head, struct class, devices))->mutex), 0); \
> > > >         pos = list_entry(pos->member.next, typeof(*pos), member))
> > >
> > I'm wrong, it's same as before indeed.
> >
> > > Eeek, just make the thing a function please, where you pass the iterator
> > > function in, like the driver core has (driver_for_each_device)
> >
> > Ok, so need a new member of knode_class, I will update the patch later.
> > Thanks.
>
> Withdraw my post, sorry :)
>
> For now the mutex patch, I will only use the mutex to lock the devices list and write an iterater function.
> Most of the iterating is for finding some device in the list, so maybe need a match function just like drivers do?
>

Drop one more mail address of David Brownell in cc list.
Sorry for this, david
