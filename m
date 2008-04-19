Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYDSDEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYDSDEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbYDSDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:04:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbYDSDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:04:17 -0400
Date: Fri, 18 Apr 2008 20:04:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up non-smp usage of cpu maps
Message-Id: <20080418200414.16dbe916.akpm@linux-foundation.org>
In-Reply-To: <4809573E.4010406@sgi.com>
References: <200804181736.m3IHatLo009568@hera.kernel.org>
	<20080418184921.87934c3f.akpm@linux-foundation.org>
	<4809573E.4010406@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 19:21:50 -0700 Mike Travis <travis@sgi.com> wrote:

> Andrew Morton wrote:
> > On Fri, 18 Apr 2008 17:36:55 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> > 
> >>     x86: clean up non-smp usage of cpu maps
> >>     
> >>     Cleanup references to the early cpu maps for the non-SMP configuration
> >>     and remove some functions called for SMP configurations only.
> >>     
> >> ...
> >>
> >> index 1179aa0..dc79409 100644
> >> --- a/arch/x86/kernel/setup.c
> >> +++ b/arch/x86/kernel/setup.c
> >> @@ -10,7 +10,7 @@
> >>  #include <asm/setup.h>
> >>  #include <asm/topology.h>
> >>  
> >> -#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
> >> +#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
> > 
> > This implies that we can have
> > 
> > 	CONFIG_HAVE_SETUP_PER_CPU_AREA && !CONFIG_SMP
> > 
> > which a) appears to be true and b) seems rather dumb?
> 
> Yeah, I kind of picked that up in a code merge and didn't really look at it
> too closely.  I should have checked the Kconfig file to make sure that it
> couldn't inadvertently get set if SMP is not set.

config HAVE_SETUP_PER_CPU_AREA
	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)

it _can_ get set at present on x86_64, which I assume is incorrect.
