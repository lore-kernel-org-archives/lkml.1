Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZASSqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZASSqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZASSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:45:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:57993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZASSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:45:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,290,1231142400"; 
   d="scan'208";a="482886796"
Date: Mon, 19 Jan 2009 10:45:47 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090119184547.GC31356@linux-os.sc.intel.com>
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com> <20090117174224.GA1409@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117174224.GA1409@ucw.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 09:42:25AM -0800, Pavel Machek wrote:
> On Fri 2009-01-09 14:48:04, Suresh Siddha wrote:
> > On Fri, Jan 09, 2009 at 02:39:31PM -0800, H. Peter Anvin wrote:
> > > Suresh Siddha wrote:
> > > >
> > > > Here X is trying to map first 8KB of memory using /dev/mem. Existing
> > > > code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
> > > > code changes don't allow to map memory with different attributes
> > > > at the same time.
> > > >
> > >
> > > Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should
> > > be WB.
> >
> > While in reality it is RAM, we have CONFIG_STRICT_DEVMEM which doesn't allow
> > apps to map RAM pages using /dev/mem. And to allow app's to map the
> > legacy 0-4KB bios data page, we consider it as non-RAM.
> 
> Fix config_strict_devmem? Ram is ram, and we should not li for
> strict_devmem benefit...

This is not just related to CONFIG_STRICT_DEVMEM. This is how we track
the PAT attribute for this 1MB physical address range even in the case of
!CONFIG_STRICT_DEVMEM

In some portions of the x86 code, we treat legacy first 1MB as special.
CONFIG_STRICT_DEVMEM is one of them.

For this range, we don't really follow what e820 says about this region. For
example, for some of the systems, e820 table doesn't even include some portions
of this 1MB region etc.

I looked at including this 1MB check in page_is_ram(). But this routine
is called at various generic places (like mem_init() where it really needs
to know what e820 says etc).

thanks,
suresh
