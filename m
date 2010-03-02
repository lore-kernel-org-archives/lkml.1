Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0CBGkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:40:05 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:57814 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0CBGkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:40:02 -0500
Date: Tue, 2 Mar 2010 07:40:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 08/12] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Message-ID: <20100302064000.GA2379@osiris.boeblingen.de.ibm.com>
References: <cover.1267214186.git.jbaron@redhat.com>
 <4aefea222db757a76ca70f20b6165e5084b99e8e.1267214186.git.jbaron@redhat.com>
 <20100228100902.GA2330@osiris.boeblingen.de.ibm.com>
 <20100301210522.GA2676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301210522.GA2676@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 04:05:22PM -0500, Jason Baron wrote:
> On Sun, Feb 28, 2010 at 11:09:02AM +0100, Heiko Carstens wrote:
> > For architectures which select CONFIG_HAVE_SYSCALL_WRAPPERS this adds
> > unnecessary sign extension code to each compat syscall.
> > On the other hand we could get rid partly of the arch specific sign extension
> > code but that would need some other changes before as well.
> > For example this one:
> > 
> > asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
> >                 struct timezone __user *tz)
> > 
> > should be converted to a function which takes two compat_uptr_t's and let
> > the syscall code itself do the proper pointer conversion (compat_ptr()).
> > 
> > Besides that the syscall alias names for these compat calls do look a
> > bit strange:
> > 
> > 000000000008b57c T SyScompat_sys_adjtimex
> > 000000000008b57c T compat_sys_adjtimex
> > 
> > That needs to be fixed as well.
> > Or simply add a 1:1 wrapper independent of CONFIG_HAVE_SYSCALL_WRAPPERS.
> 
> ok, the later suggestion seems simpler. Below I've re-spun patch #6 and
> #8. how do they look?

Looks good to me! :)
