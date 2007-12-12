Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXLLG4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXLLG4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbXLLGzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:55:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbXLLGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:55:51 -0500
Date: Tue, 11 Dec 2007 22:56:26 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 boot : export boot_params via sysfs
Message-ID: <20071212065626.GB28963@kroah.com>
References: <1197391749.17188.8.camel@caritas-dev.intel.com> <20071211184012.a84fff36.akpm@linux-foundation.org> <a8e1da0712112042w455caf55jab4f312dd356d57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712112042w455caf55jab4f312dd356d57@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:42:48PM +0800, Dave Young wrote:
> On Dec 12, 2007 10:40 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 11 Dec 2007 16:49:09 +0000 "Huang, Ying" <ying.huang@intel.com> wrote:
> >
> > > This patch export the boot parameters via sysfs. This can be used for
> > > debugging and kexec.
> > >
> > > The files added are as follow:
> > >
> > > /sys/kernel/boot_params/data  : binary file for struct boot_params
> > > /sys/kernel/boot_params/version       : boot protocol version
> >
> > Your patch uses kobject_create_and_register() which was added in Greg's
> > driver tree as of 2.6.24-rc4-mm1.
> >
> > However for some reason kobject_create_and_register() has magically vanished
> > from Greg's current driver tree so I cannot carry this patch, sorry.
> 
> Seems kobject_create_and_register would be replaced by
> kobject_create_and_add, and the uevent handling would be separated
> from original create_and_register onefunction.
> 
> wait for greg's patches or modify to use:
> 
> kobject_init
> kobject_add
> kobject_uevent
> 
> BTW, I suspect whether the uevent is really needed for boot_params object.

Oh, if you want, I'd be glad to add this to my tree as I am messing with
the kobject API a lot and I don't mind keeping it with the other kobject
patches so that it is known to work properly :)

Just forward it on to me if you want me to fix it up and add it to my
tree.

thanks,

greg k-h
