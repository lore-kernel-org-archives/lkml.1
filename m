Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbYDXSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbYDXSoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYDXSoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:44:20 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46667 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYDXSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:44:19 -0400
Date: Thu, 24 Apr 2008 12:44:17 -0600
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: lenb@kernel.org, linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Create 'slot'
	sysfsattributein/sys/devices/system/cpu/cpuN/topology/
Message-ID: <20080424184417.GA32553@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
	linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080310222735.GA22619@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECCBFA9D@orsmsx424.amr.corp.intel.com> <20080319233140.GD16237@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECE13C6E@orsmsx424.amr.corp.intel.com> <20080326185912.GA30749@ldl.fc.hp.com> <20080421052450.GA24055@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843EC012664E0@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC012664E0@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

* Luck, Tony <tony.luck@intel.com>:
> > I noticed that this patch wasn't in the git tree you sent to
> > Linus for 2.6.26. I don't remember seeing a NACK though -- is
> > there something that I could rework to make it more acceptable?
> 
> I'm mostly ok with this version of the patch.  I didn't see any
> comments from the linux-kernel crowd on the whether they are fond
> of the new API ("slot" file in cpu/cpuN/topology/) and hate to make
> the presumption that because they are silent that they agree.
> 
> The "mostly ok" part would transform to "fully ok" if there were a way
> to make sure the "slot" files only appeared on systems where they are
> meaningful (i.e. have a value other then -1 in them).  If there is
> an easy way to make this happen, then it would make me happier (less
> clutter in /sys) and perhaps others too (since this API is only useful
> on large systems where "slot" is meaningful, and there is generally
> some bias from the community at large about adding interfaces that
> aren't needed for normal desktop/laptop systems).

Yeah, I agree that the first few attempts weren't so great. I
don't really like the idea of adding a new 'slot' file to sysfs
either.

I reworked this patch to play nicer with the current topology
stuff.

I've also included a cleanup patch that you might be happy to see
(removes the noisy ia64_sal_pltid failed with -1 printk).

Tested on an hp rx4640 with Madisons and verified that I actually
get sane output in /proc/cpuinfo:

[root@max ~]# cat /proc/cpuinfo | grep processor
processor  : 0
processor  : 1
processor  : 2
processor  : 3
[root@max ~]# cat /proc/cpuinfo | grep physical
physical id: 0
physical id: 1
physical id: 2
physical id: 3

Also tested on a Tiger and verified that /proc/cpuinfo remains
unchanged, and no useless printk's appear during boot.

Thanks.

/ac

