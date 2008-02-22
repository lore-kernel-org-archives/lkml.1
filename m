Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbYBVBNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbYBVBNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYBVBN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:13:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:40926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYBVBN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:13:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="522618791"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 17:13:20 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802211643140.19896@woody.linux-foundation.org> <200802220154.57051.rjw@sisk.pl>
In-Reply-To: <200802220154.57051.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211713.20713.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2008 4:54 pm Rafael J. Wysocki wrote:
> On Friday, 22 of February 2008, Linus Torvalds wrote:
> > On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:
> > > -	if (state.event == PM_EVENT_SUSPEND) {
> > > +	if (state.event == PM_EVENT_SUSPEND && !in_hibernation_power_off()) {
> >
> > I don't understand why hibernation just doesn't use a PM_EVENT_HIBERNATE,
> > and be done with it?
> >
> > Why should it be called PM_EVENT_SUSPEND when it isn't?
> >
> > Adding some external global variables is absolutely the wrong way to fix
> > this.
> >
> > It's not even like there are very many drivers who actually care about
> > "state.event" anyway: a 'git grep' returns just 35 users in the whole
> > tree, so if this was done this ugly way just to avoid double-chcking the
> > other cases that compare against PM_EVENT_SUSPEND, then it really wasn't
> > worth it.
>
> Please relax, we're debugging the thing right now and the patch doesn't
> even seem to help on the other affected box.

Actually, looks like I forgot to reboot between tests (just rmmod'd & 
modprobed i915), your patch actually does work.

However, making new PM event messages might be a good thing anyway, assuming 
Linus takes it for 2.6.25, since it should make the migration to ->hibernate 
callbacks easier.

Jesse
