Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbYBVKnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbYBVKnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYBVKnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:43:31 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:50442 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbYBVKn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:43:29 -0500
Date: Fri, 22 Feb 2008 10:37:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Message-ID: <20080222103727.GA25781@srcf.ucam.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com> <200802211623.55450.jesse.barnes@intel.com> <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 08:42:15AM +0800, Jeff Chua wrote:
> On Fri, Feb 22, 2008 at 8:23 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> 
> >  Your system (either your distro suspend/resume scripts or your platform) must
> >  be running the video BIOS at resume time, otherwise it would probably come
> >  back blank.
> 
> But I don't think so, unless acpid is doing just that. In my
> suspend/resume event script, it's just doing a simple s2ram (without
> options), and exit after resume.

The s2ram command has a built-in whitelist used to set up video 
rePOSTing. If you want to test, reboot and do

echo mem >/sys/power/state

without i915 being loaded. If you get a console back on resume then the 
platform is reinitialising video for you, but otherwise it's your 
userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
