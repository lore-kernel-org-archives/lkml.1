Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYAEVLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYAEVLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYAEVLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:11:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954AbYAEVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:11:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sat, 5 Jan 2008 22:13:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801051537450.26040-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801051537450.26040-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801052213.39891.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Alan Stern wrote:
> On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> 
> > > Another thing to watch out for: Just in case somebody ends up calling
> > > destroy_suspended_device(dev) from within dev's own resume method, you 
> > > should interchange the resume_device() and the list_move_tail() 
> > > calls in dpm_resume().
> > 
> > However, if we unregister them all at once after releasing pm_sleep_rwsem,
> > that shouldn't be necessary, right?
> 
> It's still necessary, because destroy_suspended_device() still has to
> move the device from one list to another.  You don't want it to end up 
> on the dpm_locked list.

Hmm.  That means we'd have to do the same thing in dpm_power_up() in case
someone calls destroy_suspended_device() from resume_device_early(dev).

Still, even doing that is not enough, since someone can call
destroy_suspended_device() from a .suspend() routine and then the device
will end up on a wrong list just as well.

Greetings,
Rafael


