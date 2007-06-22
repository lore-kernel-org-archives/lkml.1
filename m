Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXFVWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXFVWvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXFVWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:50:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46069 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbXFVWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:50:52 -0400
Date: Fri, 22 Jun 2007 23:54:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai.Lu@Sun.COM
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070622235456.08999aa7@the-village.bc.nu>
In-Reply-To: <467C5074.6050103@sun.com>
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
	<20070622231951.4d516215@the-village.bc.nu>
	<m1tzszaadm.fsf@ebiederm.dsl.xmission.com>
	<467C5074.6050103@sun.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 15:43:00 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Eric W. Biederman wrote:
> > The original design came from thinking about systems where using the iommu
> > was mandatory.  I think we almost always reserve memory below 1G for the kexec
> > on panic kernel so it really shouldn't be an issue in that case.  Except
> > we need to pass an option to force not using the iommu.  I don't think
> > noiommu or swiotlb is going to make any real difference.
> > 
> > So I'm totally in favor of turning off features if we don't need them and we
> > don't take a tremendous performance hit.  (People get grumpy when writing
> > all of memory to disk takes completely unreasonable amounts of time).
> 
> 
> So you prefer to
> add diable_gart in shutdown or suspend func and let kexec to use swiotlb comand line?

Don't disable it, just don't touch it or any of its mappings. Leave it
*alone*, and use swiotlb. That'll maximise the ability to recover stuff
from the kexec kernel (since for one you may want to dump the gart when a
3d app goes kerblam)

Alan
