Return-Path: <linux-kernel-owner+w=401wt.eu-S932166Ab0AFMoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0AFMoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 07:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139Ab0AFMoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 07:44:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab0AFMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 07:44:16 -0500
Date: Wed, 6 Jan 2010 04:43:04 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       brgerst@gmail.com, hpa@zytor.com
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <20100106112133.GA5815@lenovo>
Message-ID: <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX192KG7gpIOUgjQJuBzeXoxteBjOYbtmG+dFucO
 68fP9ZyoCXFkd/J7Gp9KYawdjkbESB5cbfEBdjrgiRWI0jsu9m
 EEG7fY77f4g61s2qG2QsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 at 14:21, Cyrill Gorcunov wrote:
> > ------------[ cut here ]------------
> > WARNING: at /mnt/d1/linux-2.6-git/arch/x86/kernel/apic/apic_noop.c:130 
> > noop_apic_write+0x40/0x50()
> > Modules linked in:Pid: 0, comm: swapper Not tainted 2.6.32 #1
> > Call Trace:
> >  [<ffffffff81032563>] ? warn_slowpath_common+0x73/0xb0
> >  [<ffffffff8101a7c0>] ? noop_apic_write+0x40/0x50
> >  [<ffffffff81334160>] ? init_hw_perf_events+0x33d/0x3dd
> >  [<ffffffff8100622f>] ? xen_restore_fl_direct_end+0x0/0x1
> >  [<ffffffff81333cab>] ? identify_boot_cpu+0x15/0x3e
> >  [<ffffffff81333dfe>] ? check_bugs+0x9/0x2e
> >  [<ffffffff8132ec6e>] ? start_kernel+0x324/0x334
> > ---[ end trace a7919e7f17c0a725 ]---
> > 
> This one should be fixed by the commit 125580380f418000b1a06d9a54700f1191b6e561
> I believe.

Thanks, so within this particular bisection that would mean it's a "good" 
revision - it won't but because it doesn't have this fix, but it's not the 
same the initial problem.

I've run a few more bisections and this is where I have arrived now:

http://nerdbynature.de/bits/2.6.33-rc2/xen/bisect/git-bisect_finished.log

...with the last iteration being:


# git bisect good
3bd95dfb182969dc6d2a317c150e0df7107608d3 is the first bad commit
commit 3bd95dfb182969dc6d2a317c150e0df7107608d3
Author: Brian Gerst <brgerst@gmail.com>
Date:   Wed Dec 9 12:34:40 2009 -0500

    x86, 64-bit: Move kernel_thread to C
    
    Prepare for merging with 32-bit.
    
    Signed-off-by: Brian Gerst <brgerst@gmail.com>
    LKML-Reference: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

:040000 040000 30b5dd4d6888694ca2967893ef3e662461fe9978 
0bb5fb33914aac10aaf0344fb8cff596378be52a M      arch


@Brian, hpa: I've Cc'ed you on this one, here's what I'm whining about:
             http://lkml.org/lkml/2010/1/5/489


Please let me know if this makes sense or if the bisection looks 
funny/invalid.

Thanks,
Christian.
-- 
BOFH excuse #353:

Second-system effect.
