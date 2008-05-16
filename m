Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYEPAxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYEPAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYEPAxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:53:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYEPAxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:53:05 -0400
Date: Thu, 15 May 2008 20:51:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080516005121.GA6926@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080514205204.GJ30469@redhat.com> <1210830110.23707.141.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210830110.23707.141.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 01:41:50PM +0800, Huang, Ying wrote:
> Hi, Vivek,
> 
> On Wed, 2008-05-14 at 16:52 -0400, Vivek Goyal wrote:
> [...]
> > Ok, I have done some testing on this patch. Currently I have just
> > tested switching back and forth between two kernels and it is working for
> > me.
> > 
> > Just that I had to put LAPIC and IOAPIC in legacy mode for it to work. Few
> > comments/questions are inline.
> 
> It seems that for LAPIC and IOAPIC, there is
> lapic_suspend()/lapic_resume() and ioapic_suspend()/ioapic_resume(),
> which will be called before/after kexec jump through
> device_power_down()/device_power_up(). So, the mechanism for
> LAPIC/IOAPIC is there, we may need to check the corresponding
> implementation.
> 

ioapic_suspend() is not putting APICs in Legacy mode and that's why
we are seeing the issue. It only saves the IOAPIC routing table entries
and these entries are restored during ioapic_resume().

But I think somebody has to put APICs in legacy mode for normal 
hibernation also. Not sure who does it. May be BIOS, so that during
resume, second kernel can get the timer interrupts.

Thanks
Vivek
