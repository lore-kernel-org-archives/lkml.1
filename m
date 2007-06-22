Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbXFVVdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbXFVVdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXFVVdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:33:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43624 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXFVVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:33:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
Date: Fri, 22 Jun 2007 15:32:53 -0600
In-Reply-To: <20070622213327.69663288@the-village.bc.nu> (Alan Cox's message
	of "Fri, 22 Jun 2007 21:33:27 +0100")
Message-ID: <m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> You've got mapped live gart pages from the previous kernel. Even if you
> disable the gart before a memset you may well have the video card using
> gart translations and possibly live IOMMU mappings for devices using it
> via bus mastering - and those will cause you MCE exceptions with a
> corrupt cpu context flag (ie not nicely recoverable).

The original plan (which we have not followed up on).  Was to reserve
a chunk of any iommu for the kexec on panic kernel.  Then to just
have the second kernel use that unused chunk.  This is how we
treat the normal memory space and it seems a nice and simple approach
to this kind of problem.

For a normal kexec we should shut everything down before the kernel
transition so it should not be an issue.

YH do you think you can look at simply reserving a portion of the iommu?
And having the kexec on panic kernel use the reserved portion?

Eric
