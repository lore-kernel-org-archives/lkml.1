Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYEYRIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYEYRIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYEYRIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:08:30 -0400
Received: from www.tglx.de ([62.245.132.106]:48517 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYEYRI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:08:29 -0400
Date: Sun, 25 May 2008 19:07:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] tip/x86/nmi nmi-32/64.c merge v3
In-Reply-To: <20080525170004.GA6911@cvg>
Message-ID: <alpine.LFD.1.10.0805251905320.3295@apollo.tec.linutronix.de>
References: <4838373b.0637560a.7ce5.3f01@mx.google.com> <alpine.LFD.1.10.0805251842360.3295@apollo.tec.linutronix.de> <20080525170004.GA6911@cvg>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Cyrill Gorcunov wrote:

> [Thomas Gleixner - Sun, May 25, 2008 at 06:44:28PM +0200]
> | On Sat, 24 May 2008, Cyrill Gorcunov wrote:
> | 
> | > This series tries to merge down nmi_32/64.c to nmi.c. It is done by small
> | > steps in hope it would help to bisect problems (which will appear anyway ;)
> | > Please review *carefully* since it is NMI what I've touched (and I'm not
> | > nmi specialist). So I really apreciate _ANY_ comments on this. The series
> | > is produced over today 'tip' tree branch 'x86/nmi'.
> | 
> | Cyrill,
> | 
> | very good job. I did a short review and found no obvious problems
> | yet. Will have a closer look when I apply it.
> | 
> | Thanks,
> | 	tglx
> | 
> | 
> | 
> 
> thanks Thomas, unfortunelly I think the problems will arise soon,
> I've just noticed the commit 
> 
> commit 57b2b8947a5f68e59d5f50ab749efdc79d9ba040
> Author: Mike Travis <travis@sgi.com>
> Date:   Mon May 12 21:21:12 2008 +0200
> 
>     x86: fix remove cpu_pda table patch
> 
> in tip/testing tree
> 
> so we will need some workaround for check_nmi_watchdog() 'cause of  changing
> 
> ...
> -	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
> +	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);

Nothing to worry for you. Your patch applies fine on the x86/nmi
branch and the merge conflict is easy to resolve.

Thanks for noticing.

       tglx

