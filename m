Return-Path: <linux-kernel-owner+w=401wt.eu-S934837AbYD1OO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbYD1OO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbYD1OOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:14:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52178 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934763AbYD1OOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:14:08 -0400
Date: Mon, 28 Apr 2008 15:14:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Zhang, Xiantao" <xiantao.zhang@intel.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       kvm-ia64-devel@lists.sourceforge.net
Subject: Re: [kvm-ia64-devel] [PATCH] ia64 kvm fixes for O=... builds
Message-ID: <20080428141402.GD5882@ZenIV.linux.org.uk>
References: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk> <42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42DFA526FC41B1429CE7279EF83C6BDC011CA51F@pdsmsx415.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:46:44PM +0800, Zhang, Xiantao wrote:
> >  kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o
> >  	mmio.o \ vtlb.o process.o
> >  #Add link memcpy and memset to avoid possible structure assignment
> > error -kvm-intel-objs += memset.o memcpy.o
> > +kvm-intel-objs += ../lib/memset.o ../lib/memcpy.o
> >  obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
> 
> I don't think it is workable for kvm-ia64.  Currently,  kvm-intel module
> needs to be relocated at insertion time, so the code is
> position-indenpent. Howerver, lib/*.memset.o(memcoy.o) are not compiled
> as position independent code, they can't be linked into the module
> correctly in your way. That is why we use symbol link instead of linking
> the objects under /lib. 

symlinks won't work as you use them.  If you really need separately
compiled, use file with a couple of #include "../lib/......S" and
be done with that.
