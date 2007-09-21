Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbXIUUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbXIUUCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761741AbXIUUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:02:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbXIUUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:02:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 22:15:25 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212215.26978.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 21:45, Alan Stern wrote:
> On Fri, 21 Sep 2007, Rafael J. Wysocki wrote:
> 
> > > > Well, the problem is that apparently some systems (eg. my HP nx6325) expect us
> > > > to execute the _PTS ACPI global control method before creating the image _and_
> > > > to execute acpi_enter_sleep_state(ACPI_STATE_S4) in order to finally put the
> > > > system into the sleep state.  In particular, on nx6325, if we don't do that,
> > > > then after the restore the status of the AC power will not be reported
> > > > correctly (and if you replace the battery while in the sleep state, the
> > > > battery status will not be updated correctly after the restore).  Similar
> > > > issues have been reported for other machines.
> > > 
> > > Suppose that instead of using ACPI S4 state at all, you instead just
> > > power off.  Yes, you'll lose wakeup event functionality, and flashy
> > > LEDs, but doesn't this take care of the problem?
> > 
> > Nope.
> > 
> > > The firmware shouldn't see the hibernate as anything other than a shutdown
> > > and reboot.
> > 
> > Actually, this assumption is apparently wrong.
> 
> One gets the impression that the hibernation image includes a memory 
> area used by the firmware.  That could explain why devices need to be 
> in a low-power state when the image is created -- so that when the 
> image is restored, the firmware doesn't get confused about the device 
> states.
> 
> It would also explain why the firmware sees
> resume-from-power-off-hibernation as different from a regular reboot:
> because its data area gets overwritten as part of the resume.
> 
> In reality it's probably more complicated than this, with weird 
> interactions between the firmware and the various ACPI methods.  
> Nevertheless, the main idea seems valid.

I guess so, but I'm not sure.

The ACPI NVS area is explicitly marked as reserved and we don't save it.
On x86_64 we don't save any memory areas marked as reserved and yet the above
happens.

Greetings,
Rafael
