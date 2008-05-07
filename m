Return-Path: <linux-kernel-owner+w=401wt.eu-S1763833AbYEGPkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763833AbYEGPkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763531AbYEGPj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:39:57 -0400
Received: from xenotime.net ([66.160.160.81]:59380 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761182AbYEGPjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:39:54 -0400
Date: Wed, 7 May 2008 08:39:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Li Zefan <lizf@cn.fujitsu.com>, akpm <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au
Cc: Shen Feng <shen@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] x86: remove printk compiling warning
Message-Id: <20080507083946.49a3b5ab.rdunlap@xenotime.net>
In-Reply-To: <482167DF.4020200@cn.fujitsu.com>
References: <482162E5.7030606@cn.fujitsu.com>
	<482167DF.4020200@cn.fujitsu.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:27:11 +0800 Li Zefan wrote:

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

Hi,
Thanks for the detective work.  I hadn't looked into this yet.

Yes, my patch was sent for linux-next.  How are we supposed to
keep this straightened out?

---
~Randy
