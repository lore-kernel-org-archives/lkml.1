Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbXFVVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbXFVVqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbXFVVpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:45:55 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:50426 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760236AbXFVVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:45:53 -0400
Date: Fri, 22 Jun 2007 14:45:39 -0700
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070622214539.GA8795@rhun.ibm.com>
References: <200706221219.16243.yinghai.lu@sun.com> <20070622193124.GG5051@rhun.smartcity.com> <20070622213327.69663288@the-village.bc.nu> <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 03:32:53PM -0600, Eric W. Biederman wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> > You've got mapped live gart pages from the previous kernel. Even
> > if you disable the gart before a memset you may well have the
> > video card using gart translations and possibly live IOMMU
> > mappings for devices using it via bus mastering - and those will
> > cause you MCE exceptions with a corrupt cpu context flag (ie not
> > nicely recoverable).
> 
> The original plan (which we have not followed up on).  Was to
> reserve a chunk of any iommu for the kexec on panic kernel.  Then to
> just have the second kernel use that unused chunk.  This is how we
> treat the normal memory space and it seems a nice and simple
> approach to this kind of problem.
> 
> For a normal kexec we should shut everything down before the kernel
> transition so it should not be an issue.
> 
> YH do you think you can look at simply reserving a portion of the
> iommu?  And having the kexec on panic kernel use the reserved
> portion?

How would this work with an isolation capable IOMMU which has
different address spaces for different devices? (e.g., Calgary which
is in mainline, Intel's VT-d which is coming soon, etc).

Cheers,
Muli
