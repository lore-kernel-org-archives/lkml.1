Return-Path: <linux-kernel-owner+w=401wt.eu-S964858AbYBVA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbYBVA4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936534AbYBVA40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:56:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936505AbYBVA4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:56:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Date: Fri, 22 Feb 2008 01:54:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802220131.09525.rjw@sisk.pl> <alpine.LFD.1.00.0802211643140.19896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802211643140.19896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802220154.57051.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of February 2008, Linus Torvalds wrote:
> 
> On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:
> >  
> > -	if (state.event == PM_EVENT_SUSPEND) {
> > +	if (state.event == PM_EVENT_SUSPEND && !in_hibernation_power_off()) {
> 
> I don't understand why hibernation just doesn't use a PM_EVENT_HIBERNATE, 
> and be done with it?
> 
> Why should it be called PM_EVENT_SUSPEND when it isn't?
> 
> Adding some external global variables is absolutely the wrong way to fix 
> this.
> 
> It's not even like there are very many drivers who actually care about 
> "state.event" anyway: a 'git grep' returns just 35 users in the whole 
> tree, so if this was done this ugly way just to avoid double-chcking the 
> other cases that compare against PM_EVENT_SUSPEND, then it really wasn't 
> worth it.

Please relax, we're debugging the thing right now and the patch doesn't
even seem to help on the other affected box.

The issue appears to be more complicated than we initially thought.

Thanks,
Rafael
