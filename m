Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYIYDBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYIYDBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYIYDAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:00:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYIYDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:00:50 -0400
Date: Wed, 24 Sep 2008 19:55:50 -0700
From: Greg KH <greg@kroah.com>
To: Yan Li <elliot.li.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, joerg.roedel@amd.com,
       rjmaomao@gmail.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
Message-ID: <20080925025550.GA15249@kroah.com>
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <20080925022325.GA14390@kroah.com> <20080925024748.GG21049@yantp.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925024748.GG21049@yantp.cn.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:47:48AM +0800, Yan Li wrote:
> On Wed, Sep 24, 2008 at 07:23:25PM -0700, Greg KH wrote:
> > On Wed, Sep 24, 2008 at 08:22:10PM +0800, Yan Li wrote:
> > > Detects whether we are running as a VMware guest or not. Detection is
> > > based upon DMI vendor string.
> > > 
> > > It provides a function:
> > > int is_vmware_guest(void)
> > > that can be used easily to detect if we are running as a VMware guest
> > > or not.
> > 
> > Why do we need to do this within the kernel, what is that going to
> > achieve?
> > 
> > People can do this easily in userspace if they need to detect this, I
> > think there's a patch for util-linux-ng adding such a simple utility
> > that handles almost all of the known virtualization engines right now.
> 
> Hi Greg,
> 
> For me this is used in the next patch (for mtrr/main.c) to suppress an
> unnecessary warning when running as a VMware guest:
> http://lkml.org/lkml/2008/9/24/144

But that has been stated it's a vmware bug, not a kernel bug :)

> We already have code to suppress warning under KVM so the above patch
> suppress warnings for VMware guest also.
> 
> H. Peter Anvin and Alok kataria are also proposing we may need a more
> general approach for detecting hypervisors that can be used for some
> other quirks.

Well, having a config option like this isn't the way to go as it will be
forced on for all distros and users anyway.

A simple cpuid test is the easier way to do this, that's what the
userspace tools do, if it's really needed in the kernel.  But hopefully,
such things shouldn't be needed within the kernel as it's not Linux's
fault that the hypervisor has bugs in it :)

We wouldn't be wanting to work around bugs in Microsoft's hypervisor,
would we?

thanks,

greg k-h
