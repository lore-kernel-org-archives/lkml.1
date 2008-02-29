Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYB2ACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYB2ACo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYB2ACe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:02:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53772 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYB2ACd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:02:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Fri, 29 Feb 2008 01:01:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <Pine.LNX.4.44L0.0802281741030.2180-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802281741030.2180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802290101.06650.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 28 of February 2008, Alan Stern wrote:
> Rafael:

Hi,

> Here's my patch.  It doesn't include the timers for deadlock debugging, 
> but it does include all the other stuff we've been talking about.  My 
> base probably isn't quite in sync with yours, so this may not apply 
> cleanly on your system.  But the divergences should be small.

No big deal.  In fact we're working with Alex on a patch that modifies main.c
too, so I'll have to resolve merging conflicts anyway. ;-)

> Incidentally, there seemed to be a bug in your dpm_suspend() -- the 
> dpm_list_mtx needs to be reacquired before the error checking.

Oh, yes.  Will you please send a fix when
http://marc.info/?l=linux-acpi&m=120389632114090&w=4 is merged?

> This patch fixes that.  It also removes pm_sleep_rwsem, which isn't used 
> any more.

Yeah.  I left pm_sleep_rwsem, because I wasn't sure it would be necessary
in the future.

> We should think about device_pm_schedule_removal().  It won't work
> right if a suspend method calls it for the device being suspended, 
> because the device gets moved to the dpm_off list after the method 
> runs.

I think we should remove device_pm_schedule_removal() early in the 2.6.26
cycle.

I'll review the patch more thoroughly tomorrow, since I have some new material
for the regressions list I need to take care of.

Thanks,
Rafael
