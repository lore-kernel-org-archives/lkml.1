Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbXH1BXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbXH1BXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXH1BXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:23:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:4943 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbXH1BXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:23:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,314,1183359600"; 
   d="scan'208";a="289104235"
Subject: Re: [RFC][PATCH 0/2 -mm] kexec based hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070827131549.GA4104@ucw.cz>
References: <1188177245.3247.36.camel@caritas-dev.intel.com>
	 <20070827050027.GB9809@in.ibm.com>
	 <1188195529.3247.82.camel@caritas-dev.intel.com>
	 <20070827075317.GB2060@elf.ucw.cz>
	 <m1d4x95dqy.fsf@ebiederm.dsl.xmission.com>  <20070827131549.GA4104@ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 09:24:29 +0800
Message-Id: <1188264269.2050.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 28 Aug 2007 01:23:31.0187 (UTC) FILETIME=[0B50B430:01C7E912]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 13:15 +0000, Pavel Machek wrote:
> Hi!
> 
> > >> > Does this make sense?
> > >> 
> > >> Yes, this is a sensible optimization. But I think it may be better to
> > >> make bootloader load kernel D directly into a specified memory location.
> > >> For example, we can add a option to "kernel" command of grub. 
> > >> 
> > >> And, I think we can do more in bootloader. Such as we can prepare
> > >> two
> > >
> > > Yes, that would be nice.
> > >
> > > It will mean quite a bit of work, but I guess it should be the long
> > > term goal. Loading restore kernel directly from bootloader means:
> > >
> > > 1) it is fast -- no need to boot another kernel
> > >
> > > 2) it is "classical" way of doing things
> > >
> > > On the other hand, we loose flexibility that way:
> > >
> > > 1) it locks you onto one bootloader
> > >
> > > 2) you no longer have userland there to do uncompression, decryption,
> > > etc..
> > 
> > True although for the uncompression and decryption those aren't exactly foreign
> > requirements for bootloaders.
> 
> Well, uncompression yes, but crypto? What is that, some kind of
> trusted computing thingie?
> 
> We do RSA for uswsusp, that may be a bit of problem for a bootloader,
> but I'm glad bootloaders are bloated already :-).

As far as I know, the grub 2.0 uses a modular implementation scheme.
That is, every OS loader (Multi-boot, Linux, FreeBSD etc), partition
table, file system is implemented as a module, and these modules can be
statically linked into the final image.

So I think the hibernation image loading can be implemented in grub 2.0
in a manageable way. :)

Best Regards,
Huang Ying
