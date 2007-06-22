Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbXFVVmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbXFVVmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbXFVVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:41:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43472 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbXFVVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:41:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Yinghai Lu <Yinghai.Lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<200706222328.21259.ak@suse.de>
Date: Fri, 22 Jun 2007 15:41:24 -0600
In-Reply-To: <200706222328.21259.ak@suse.de> (Andi Kleen's message of "Fri, 22
	Jun 2007 23:28:20 +0200")
Message-ID: <m14pkzbraz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Friday 22 June 2007 22:33, Alan Cox wrote:
>> You've got mapped live gart pages from the previous kernel. Even if you
>> disable the gart before a memset 
>
> It's probably too late then. It could also interfere with other operations.
> If anything the GART should be disabled during kexec shutdown. Perhaps we just 
> need a suitable suspend function that does that. Eric, any preferences? 

Well it would be a shutdown method not a suspend method.  The authors of
the suspend code thought sharing code with the reboot and the rmmod case
didn't make sense.

For a normal kexec into another kernel I think this makes sense.

>> you may well have the video card using 
>> gart translations and possibly live IOMMU mappings for devices using it
>> via bus mastering - and those will cause you MCE exceptions with a
>> corrupt cpu context flag (ie not nicely recoverable).
>
> We disable those machine checks on K8 because they're not fully reliable.

For the kexec on panic not shutting the hardware down if at all possible is
the ideal.  There I think we need a mode to not touch a chunk of the iommu
and reserve it for the kexec on panic kernel (or perhaps just use the
swiotlb code if we need bounce buffers at all).

Eric
