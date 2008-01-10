Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYAJS1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYAJS1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYAJS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:27:27 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53826 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbYAJS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:27:26 -0500
Subject: Re: Driver 'sd' needs updating
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nick@ukfsn.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20080110203845E.fujita.tomonori@lab.ntt.co.jp>
References: <20080110085150.53addacf@linuxamd.linicks.net>
	 <20080110203845E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:27:22 -0600
Message-Id: <1199989642.3141.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 20:38 +0900, FUJITA Tomonori wrote:
> CC'ed linux-scsi and James,
> 
> On Thu, 10 Jan 2008 08:51:50 +0000
> Nick Warne <nick@ukfsn.org> wrote:
> 
> > 
> > Hi everybody - Happy New Year to you all!
> > 
> > OK, updated to git rc7 yesterday - I now see this in syslog:
> > 
> >    "Driver 'sd' needs updating - please use bus_type methods"
> > 
> > The warning never appeared in RC6, and all google reveals are other
> > peoples logs that are posted about other issues.
> > 
> > Do I need to fix up something here?
> 
> No, you don't. It's harmless, a side effect of:
> 
> commit 751bf4d7865e4ced406be93b04c7436d866d3684
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Wed Jan 2 11:14:30 2008 -0600
> 
>     [SCSI] scsi_sysfs: restore prep_fn when ULD is removed
> 
> 
> It would be better to silence this warning.
> 
> James, we need to reset prep_fn in each ULD? though it's not nice...

Really not nice ... to the extent that we shouldn't do it.  The reset is
in exactly the correct place currently.  If we make it a requirement of
the ULDs its duplication and someone is bound to forget.

It looks like the problem is the warning in
base/driver.c:driver_register() apparently it wants an either/or for
->remove methods (either bus type or driver).  We're actually using the
bus_type methods, but we also have a driver component, sigh.  I suppose
what it's wanting is for me to add a scsi_driver type with remove
methods ... which looks a bit silly since all of the SCSI drivers want
different remove methods.

James


