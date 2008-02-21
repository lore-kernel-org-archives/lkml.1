Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbYBUQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbYBUQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933720AbYBUQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:28:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37281 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511AbYBUQ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:28:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 17:27:20 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, Dave Airlie <airlied@linux.ie>,
       Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201639.02502.jesse.barnes@intel.com> <b6a2187b0802201800n12f90b22x8cb0c2ad6e0c402@mail.gmail.com>
In-Reply-To: <b6a2187b0802201800n12f90b22x8cb0c2ad6e0c402@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211727.21593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of February 2008, Jeff Chua wrote:
> On Thu, Feb 21, 2008 at 8:39 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > On Wednesday, February 20, 2008 4:35 pm Jeff Chua wrote:
> >  > On Thu, Feb 21, 2008 at 5:37 AM, Jesse Barnes <jesse.barnes@intel.com>
> >  wrote:
> >  > >  Ok, can you give this patch a try with the 'platform' method?  It should
> >  > > at least tell us what ACPI would like the device to do at suspend time,
> >  > > but it probably won't fix the hang.
> 
> It says "calling pci_set_power_state with 3". Then after all then it
> still hangs, and then resume with Mr Green.
> 
> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> PM: Shrinking memory...  ^H-^Hdone (0 pages freed)
> PM: Freed 0 kbytes in 0.20 seconds (0.00 MB/s)
> ACPI: Preparing to enter system sleep state S4
> Suspending console(s)
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> drm_sysfs_suspend
> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> calling pci_set_power_state with 3

So it returns the right value.

Jeff, Jesse, please check one thing for me.

Please boot 2.6.25-rc2 (or better, the current head of the Linus' tree) with
no_console_suspend and try to do the following:

# echo 8 > /proc/sys/kernel/printk
# echo core > /sys/power/pm_test
# echo disk > /sys/power/state

(that will run a test of the freeze/unfreeze code without creating the image)
and then

# echo mem > /sys/power/state

(that will run a test of the suspend/resume code without actually suspending).

I'd like to know if that works.

Thanks,
Rafael
