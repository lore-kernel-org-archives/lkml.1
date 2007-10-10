Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXJJO6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXJJO6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXJJO54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:57:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbXJJO54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:57:56 -0400
Date: Wed, 10 Oct 2007 07:57:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kevin <spaceman__spiff@cox.net>
cc: Peter Anvin <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ARPM shutdown oops (Re: [stable] [patch 09/12] Fix SMP poweroff
 hangs)
In-Reply-To: <200710092359.47144.spaceman__spiff@cox.net>
Message-ID: <alpine.LFD.0.999.0710100747120.3838@woody.linux-foundation.org>
References: <20071008180406.052382073@mini.kroah.org>
 <alpine.LFD.0.99.0710100133590.5040@localhost.localdomain>
 <alpine.LFD.0.999.0710092224000.3838@woody.linux-foundation.org>
 <200710092359.47144.spaceman__spiff@cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Oct 2007, Kevin wrote:
> 
> I don't own a digital camera but I did jot the info down by hand.

Heh, yeah, that's what I used to do too (and still do if a camera isn't 
handy).

> Call Trace:
> [<c010e852>] apm_bios_call_simple+0x92/0x110
> [<c0285a0>] acpi_hw_clear_gpe_block+00/0x32
> [<c010e8ec>] set_system_power_state+0x1c/0x30
> [<c010f93a>] apm_system_power_off+0x6a/0x80
> [<c010f8d0>] apm_system_power_off+0x0/0x80
> [<c010e434>] native_machine_power_off+0x14/0x20
> [<c010e406>] machine_power_off+0x6/0x10
> [<c0127cb9>] sys_reboot+0x99/0x140
>...
> Code: Bad EIP Value
> EIP: [<00007825>] 0x7825 SS:ESP 0068:e7305de8
> /etc/rc.d/rc.0: Line 261: 2796 Segmentation Fault   /sbin/poweroff

Ahh. APM. That does explain the strange EIP register values: we're jumping 
into the BIOS, and the BIOS is doing something unexpected.

However, that doesn't really explain the oops, because I don't think 
anything changed in APM from 2.6.22->23, and in particular, I don't think 
it has anything to do with the thing that caused problems for PPC.

We did have some APM *detection* changes, and maybe APM wasn't even 
detected for you before, or it was detected differently. That would be due 
to the bootup changes, I'm Cc'ing Peter Anvin (and the kernel mailing 
list, in case somebody else see a pattern to this).

Can you please
 - try with APM turned off (APM really shouldn't be useful on any machines 
   built in the last ten years or so), just to verify that things work 
   without APM.
 - send the bootup "dmesg" output and a machine description (and please 
   keep people Cc'd - sending things just to me is a sure-fire way to get 
   things dropped eventually, if only because I'm a lazy clutz).
 - what was the last kernel that worked (and if you can bisect the 
   problem, that would likely help enormously)

Thanks,

		Linus
