Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYEHOhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYEHOhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763365AbYEHOhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:37:01 -0400
Received: from www.tglx.de ([62.245.132.106]:53626 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763135AbYEHOg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:36:59 -0400
Date: Thu, 8 May 2008 16:36:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Shen Feng <shen@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] x86: remove printk compiling warning
In-Reply-To: <482167DF.4020200@cn.fujitsu.com>
Message-ID: <alpine.LFD.1.10.0805081635270.3318@apollo.tec.linutronix.de>
References: <482162E5.7030606@cn.fujitsu.com> <482167DF.4020200@cn.fujitsu.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Li Zefan wrote:
> CC: Randy Dunlap <rdunlap@xenotime.net>
> 
> Shen Feng wrote:
> > Since size is unsigned long, the format string is changed
> > from zd to lu.
> > 
> > Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> > ---
> >  arch/x86/kernel/setup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index cc6f5eb..c0c68c1 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -95,7 +95,7 @@ void __init setup_per_cpu_areas(void)
> > 
> >  	/* Copy section for each CPU (we discard the original) */
> >  	size = PERCPU_ENOUGH_ROOM;
> > -	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
> > +	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
> >  			  size);
> > 
> >  	for_each_possible_cpu(i) {
> 
> Let me figure out this.
> 
> Commit 0fc5035fc66d26776bebd45c508a9bce3611f388 in linux-next changed
> 'size' from unsigned long to ssize_t, causing a compile warning, and
> then Randy posted a patch to fix it:
> 	http://marc.info/?l=linux-kernel&m=120958902125650&w=2
> 
> But this patch was wrongly merged into mainline, causing the compile warning
> you described here.
> 
> So we should revert Randy's patch and re-apply it to linux-next ?

Yes, this came via Andrew and we did not notice that it was for
linux-next.

Thanks,

	tglx
