Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760Ab0AFLVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0AFLVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697Ab0AFLVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:21:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33066 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0AFLVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BYUfPuuffrc/3b4rFb+IYQE0gQt4lTrcRNNA1U7YVA4rCw7bDP16IhZPBwaRugE6nK
         1Ry+euE4BxJ47JckDAtLfCLL/3cdGrHLO0UeExjylAPhO9IZ69OEMEaTQZvkSNqZKdPN
         1u061U3baRTPTjDiaDG2NreuzZAI5a5CAZZy8=
Date: Wed, 6 Jan 2010 14:21:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100106112133.GA5815@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:06:05AM -0800, Christian Kujau wrote:
> On Wed, 6 Jan 2010 at 14:38, Jeremy Fitzhardinge wrote:
> > this message before, even during development.  I'd suspect either a compiler
> > bug, a miscompile, or some bad interaction with another patch.
> 
> I'm using the same compiler (gcc-4.4.2-8, binutils-2.20) for the 
> (working) 2.6.32 (Linus' git tree) and did a "make 
> distclean" to double check, but 2.6.33-rc2/3 just wouldn't boot.
> 
> > A bisection would be useful.
> 
> I'm *almost* there, only 1 or 2 revisions revisions left, I attached the 
> bisect log below. However, now this happens during "xm create" on the 
> DomU console:
> 
> ------------[ cut here ]------------
> WARNING: at /mnt/d1/linux-2.6-git/arch/x86/kernel/apic/apic_noop.c:130 
> noop_apic_write+0x40/0x50()
> Modules linked in:Pid: 0, comm: swapper Not tainted 2.6.32 #1
> Call Trace:
>  [<ffffffff81032563>] ? warn_slowpath_common+0x73/0xb0
>  [<ffffffff8101a7c0>] ? noop_apic_write+0x40/0x50
>  [<ffffffff81334160>] ? init_hw_perf_events+0x33d/0x3dd
>  [<ffffffff8100622f>] ? xen_restore_fl_direct_end+0x0/0x1
>  [<ffffffff81333cab>] ? identify_boot_cpu+0x15/0x3e
>  [<ffffffff81333dfe>] ? check_bugs+0x9/0x2e
>  [<ffffffff8132ec6e>] ? start_kernel+0x324/0x334
> ---[ end trace a7919e7f17c0a725 ]---
> 
...

This one should be fixed by the commit 125580380f418000b1a06d9a54700f1191b6e561
I believe.

	-- Cyrill
