Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbXFVV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbXFVV3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbXFVV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:29:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbXFVV3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:29:22 -0400
From: Andi Kleen <ak@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Date: Fri, 22 Jun 2007 23:28:20 +0200
User-Agent: KMail/1.9.1
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <20070622193124.GG5051@rhun.smartcity.com> <20070622213327.69663288@the-village.bc.nu>
In-Reply-To: <20070622213327.69663288@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706222328.21259.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 22:33, Alan Cox wrote:
> On Fri, 22 Jun 2007 12:31:24 -0700
>
> Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> > On Fri, Jun 22, 2007 at 12:19:15PM -0700, Yinghai Lu wrote:
> > > [PATCH] x86-64: disable the GART before allocate aperture
> > >
> > > For K8 system: 4G RAM with memory hole remapping enabled, or more
> > > than 4G RAM installed. when mem is allocated for GART, it will do
> > > the memset for clear.  and for kexec case, the first kernel already
> > > enable that, the memset in second kernel will cause the system
> > > restart. So disable that at first before we try to allocate mem for
> > > it.
> >
> > Why does the memset in the second kernel cause a system restart?
>
> You've got mapped live gart pages from the previous kernel. Even if you
> disable the gart before a memset 

It's probably too late then. It could also interfere with other operations.
If anything the GART should be disabled during kexec shutdown. Perhaps we just 
need a suitable suspend function that does that. Eric, any preferences? 

> you may well have the video card using 
> gart translations and possibly live IOMMU mappings for devices using it
> via bus mastering - and those will cause you MCE exceptions with a
> corrupt cpu context flag (ie not nicely recoverable).

We disable those machine checks on K8 because they're not fully reliable.

-Andi
