Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbYARRdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbYARRdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761912AbYARRdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:33:42 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36706 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762955AbYARRdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:33:40 -0500
Date: Fri, 18 Jan 2008 23:03:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andreas Herrmann3 <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080118173337.GC12009@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Andreas Herrmann3 <andreas.herrmann3@amd.com>,
	Ingo Molnar <mingo@elte.hu>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@muc.de,
	ebiederm@xmission.com, rdreier@cisco.com,
	torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
	davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
	akpm@linux-foundation.org, arjan@infradead.org,
	"Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org
References: <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com> <20080117221505.GB18883@elte.hu> <20080117225243.GH12631@alberich.amd.com> <20080117230410.GA8694@linux-os.sc.intel.com> <20080118161057.GB4636@alberich.amd.com> <924EFEDD5F540B4284297C4DC59F3DEE62B6BE@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE62B6BE@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> [2008-01-18 09:13:10]:

> 
> 
> >-----Original Message-----
> >From: Andreas Herrmann3 [mailto:andreas.herrmann3@amd.com] 
> >Sent: Friday, January 18, 2008 8:11 AM
> >To: Pallipadi, Venkatesh
> >Cc: Ingo Molnar; Siddha, Suresh B; ak@muc.de; 
> >ebiederm@xmission.com; rdreier@cisco.com; 
> >torvalds@linux-foundation.org; gregkh@suse.de; 
> >airlied@skynet.ie; davej@redhat.com; tglx@linutronix.de; 
> >hpa@zytor.com; akpm@linux-foundation.org; arjan@infradead.org; 
> >Barnes, Jesse; davem@davemloft.net; linux-kernel@vger.kernel.org
> >Subject: Re: [patch 0/4] x86: PAT followup - Incremental 
> >changes and bug fixes
> >
> >On Thu, Jan 17, 2008 at 03:04:10PM -0800, Venki Pallipadi wrote:
> >>
> >> Below is another potential fix for the problem here. Going 
> >through ACPI
> >> ioremap usages, we found at one place the mapping is cached 
> >for possible
> >> optimization reason and not unmapped later. Patch below always unmaps
> >> ioremap at this place in ACPICA.
> >
> >The patch does not fix the problem. The conflicting cache 
> >attributes are
> >still there.
> >
> 
> Andreas,
> 
> Could you also try the patch Suresh Siddha sent out yesterday. That
> covers the case where the attribute was not getting removed even after
> unmap was called.
>

An easy way for you to figure out if our patch will solve your problem
is this, look for any quirks for your device in drivers/pci/quirks.c
and or architecture specific quirks file. If you see your device in
there, then our patch is likely to solve your problem.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
