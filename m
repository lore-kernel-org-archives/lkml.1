Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbXFVW7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbXFVW7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXFVW67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:58:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46546 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbXFVW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:58:58 -0400
Date: Sat, 23 Jun 2007 00:04:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai.Lu@Sun.COM
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070623000405.15eb66f1@the-village.bc.nu>
In-Reply-To: <467C53C4.4060004@sun.com>
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
	<20070622231951.4d516215@the-village.bc.nu>
	<m1tzszaadm.fsf@ebiederm.dsl.xmission.com>
	<467C5074.6050103@sun.com>
	<20070622235456.08999aa7@the-village.bc.nu>
	<467C53C4.4060004@sun.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 15:57:08 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Alan Cox wrote:
> 
> > Don't disable it, just don't touch it or any of its mappings. Leave it
> > *alone*, and use swiotlb. That'll maximise the ability to recover stuff
> > from the kexec kernel (since for one you may want to dump the gart when a
> > 3d app goes kerblam)
> 
> How about LinuxBIOS + Kernel ===> Final kernel path?
> someday EFI(PEI) + Kernel ===> Final kernel path need that too.
> 
> or the normal kexec path still could have clean shutdown.

The kexec path for kdump should be swiotlb and leave the GART alone as
you are dumping as much state as you can and leaving stuff as is when
possible. The new-kernel case you shut everything down so you can shut
down the GART in the old kernel and re-initialise it in the new one

Alan
