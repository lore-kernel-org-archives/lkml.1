Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbXFVXPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbXFVXPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXFVXO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:14:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55811 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFVXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:14:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai.Lu@Sun.COM, Muli Ben-Yehuda <muli@il.ibm.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
References: <200706221219.16243.yinghai.lu@sun.com>
	<20070622193124.GG5051@rhun.smartcity.com>
	<20070622213327.69663288@the-village.bc.nu>
	<m18xabbrp6.fsf@ebiederm.dsl.xmission.com>
	<20070622231951.4d516215@the-village.bc.nu>
	<m1tzszaadm.fsf@ebiederm.dsl.xmission.com> <467C5074.6050103@sun.com>
	<20070622235456.08999aa7@the-village.bc.nu> <467C53C4.4060004@sun.com>
	<20070623000405.15eb66f1@the-village.bc.nu>
Date: Fri, 22 Jun 2007 17:14:23 -0600
In-Reply-To: <20070623000405.15eb66f1@the-village.bc.nu> (Alan Cox's message
	of "Sat, 23 Jun 2007 00:04:05 +0100")
Message-ID: <m1myyra8fk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Fri, 22 Jun 2007 15:57:08 -0700
> Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
>
>> Alan Cox wrote:
>> 
>> > Don't disable it, just don't touch it or any of its mappings. Leave it
>> > *alone*, and use swiotlb. That'll maximise the ability to recover stuff
>> > from the kexec kernel (since for one you may want to dump the gart when a
>> > 3d app goes kerblam)
>> 
>> How about LinuxBIOS + Kernel ===> Final kernel path?
>> someday EFI(PEI) + Kernel ===> Final kernel path need that too.
>> 
>> or the normal kexec path still could have clean shutdown.
>
> The kexec path for kdump should be swiotlb and leave the GART alone as
> you are dumping as much state as you can and leaving stuff as is when
> possible. The new-kernel case you shut everything down so you can shut
> down the GART in the old kernel and re-initialise it in the new one

Agreed.

Eric
