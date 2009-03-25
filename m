Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbZCYR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbZCYR2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZCYR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:28:27 -0400
Received: from mga05.intel.com ([192.55.52.89]:4137 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753558AbZCYR20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,420,1233561600"; 
   d="scan'208";a="441979676"
Date: Wed, 25 Mar 2009 10:32:12 -0700
From: mark gross <mgross@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Message-ID: <20090325173212.GA30701@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324203259.GC26930@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 09:32:59PM +0100, Ingo Molnar wrote:
> 
> (Cc:s added)
> 
> * Andrew Lutomirski <amluto@gmail.com> wrote:
> 
> > On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system 
> > is completely hosed on resume.  It appears that even hard disk IO 
> > didn't work (trying to do *anything* including getting a dmesg 
> > trace just spewed sda io errors to the console).  Hence no trace.  
> > I did an alt-sysrq-b and the screen went blank and the machine 
> > just started beeping at me.
> > 
> > Resume works much better with intel_iommu=off.  (I remember seeing 
> > a patch go by that purported to fix resume with IOMMU enabled, but 
> > it didn't work for me.)
> > 
> > I'd be happy to try to make a better bug report if anyone has any 
> > bright ideas.
> 
> i have a Lenovo T500 that does not even boot with with DMAR enabled 
> in the BIOS (it's default-off), i get this panic in early bootup:
> 
>     DMAR hardware is malfunctioning

That happens when the polling of the IOMMU registers fail to behave as
expected in the VT-d specification.  Typically its been a bios issue
when this happens.

> 
> So i dont get to test suspend/resume ;-)
> 
> 	Ingo
