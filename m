Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYHLO1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYHLO1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYHLO04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:26:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYHLO0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:26:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] PM: Remove WARN_ON from device_pm_add
Date: Tue, 12 Aug 2008 16:29:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <200808090105.14770.rjw@sisk.pl> <20080812125902.GB13910@cs181140183.pp.htv.fi>
In-Reply-To: <20080812125902.GB13910@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121629.53425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Adrian Bunk wrote:
> On Sat, Aug 09, 2008 at 01:05:13AM +0200, Rafael J. Wysocki wrote:
> > PM: Remove WARN_ON from device_pm_add
> > 
> > Fix message in device_pm_add() saying that the device will not be
> > added to dpm_list, although in fact the device is going to be added
> > to the list regardless of the ordering violation.
> > 
> > Remove the WARN_ON(true) triggered in that situation, because it is
> > hit by USB very often and spams the users' logs.
> > 
> > This patch fixes bug #11263
> 
> Michael Tsirkin said in #11284 (which is marked as a duplicate of #11263):
> 
> <--  snip  -->
> 
> > What exactly is this instability?
> 
> X often crashes on resume, sometimes ACPI seems to stop working
> after resume. I am trying to figure exact way to reproduce first,
> or get some relevant logs, then I'll report.
> 
> > Does 2.6.26 work fine?
> 
> yes
> 
> <--  snip  -->
> 
> 
> Is this a separate regression or did the WARN_ON different from the 
> first assumption indicate a functional regression?

No, it doesn't indicate a functional regression.

In 2.6.26 the WARN_ON() was artificially silenced by USB, but that stopped
working after the PM core had changed in 2.6.27-rc.

Thanks,
Rafael
