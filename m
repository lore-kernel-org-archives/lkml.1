Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXFVU2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXFVU2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFVU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:28:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53172 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751099AbXFVU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:28:26 -0400
Date: Fri, 22 Jun 2007 21:33:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070622213327.69663288@the-village.bc.nu>
In-Reply-To: <20070622193124.GG5051@rhun.smartcity.com>
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 12:31:24 -0700
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Fri, Jun 22, 2007 at 12:19:15PM -0700, Yinghai Lu wrote:
> > [PATCH] x86-64: disable the GART before allocate aperture
> > 
> > For K8 system: 4G RAM with memory hole remapping enabled, or more
> > than 4G RAM installed. when mem is allocated for GART, it will do
> > the memset for clear.  and for kexec case, the first kernel already
> > enable that, the memset in second kernel will cause the system
> > restart. So disable that at first before we try to allocate mem for
> > it.
> 
> Why does the memset in the second kernel cause a system restart?

You've got mapped live gart pages from the previous kernel. Even if you
disable the gart before a memset you may well have the video card using
gart translations and possibly live IOMMU mappings for devices using it
via bus mastering - and those will cause you MCE exceptions with a
corrupt cpu context flag (ie not nicely recoverable).

Alan
