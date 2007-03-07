Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXCGGXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXCGGXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932317AbXCGGXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:23:30 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40406 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbXCGGX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:23:29 -0500
Date: Wed, 7 Mar 2007 11:53:20 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>
Subject: Re: BUG() during suspend to disk (2.6.21-rc2, x86_64)
Message-ID: <20070307062320.GB5469@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070306103247.GA11002@in.ibm.com> <200703062156.46905.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703062156.46905.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 09:56:46PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Tuesday, 6 March 2007 11:32, Vivek Goyal wrote:
> > Hi,
> > 
> > I see following BUG() on serial console while hibernating on a x86_64
> > machine. I am using 2.6.21-rc2 kernel.
> 
> I see it too.
> 
> > BUG: at arch/x86_64/kernel/acpi/sleep.c:70 init_low_mapping()
> > 
> > Call Trace:
> >  [<ffffffff80214b9a>] acpi_save_state_mem+0x70/0xd6
> >  [<ffffffff8036e90e>] acpi_pm_enter+0x23/0xc1
> >  [<ffffffff8024eec4>] pm_suspend_disk+0x1ac/0x228
> >  [<ffffffff8024dc9b>] enter_state+0x50/0x1e6
> >  [<ffffffff8036ecce>] acpi_system_write_sleep+0x5c/0x79
> >  [<ffffffff8027b767>] vfs_write+0xad/0x136
> >  [<ffffffff8027bca4>] sys_write+0x45/0x6e
> >  [<ffffffff80209bbe>] system_call+0x7e/0x83
> 
> Hm, it doesn't like the fact that nonboot CPUs are online at that point, but
> we don't do anything to disable them.  Should we?
> 
> I think the appended patch might work.
> 

Yes. It does work for me. Thanks

Vivek
