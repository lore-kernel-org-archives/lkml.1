Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXC2Dsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXC2Dsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 23:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXC2Dsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 23:48:47 -0400
Received: from koto.vergenet.net ([210.128.90.7]:56714 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXC2Dsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 23:48:46 -0400
Date: Thu, 29 Mar 2007 12:48:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: fastboot@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-ID: <20070329034839.GA5973@verge.net.au>
References: <20070328061855.GA9576@verge.net.au> <20070328064353.GD4941@in.ibm.com> <20070328071315.GC29303@verge.net.au> <20070328080853.GE4941@in.ibm.com> <20070329033056.GD22141@verge.net.au> <20070329034421.GC9582@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329034421.GC9582@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 09:14:21AM +0530, Vivek Goyal wrote:
> On Thu, Mar 29, 2007 at 12:30:59PM +0900, Simon Horman wrote:
> > Hi,
> > 
> > this is a(nother) minor update to this patch. 
> > Explanation below.
> > 
> > -- 
> > Horms
> >   H: http://www.vergenet.net/~horms/
> >   W: http://www.valinux.co.jp/en/
> > 
> > [PATCH] kdump/kexec: calculate note size at compile time
> > 
> > Currently the size of the per-cpu region reserved to save crash
> > notes is set by the per-architecture value MAX_NOTE_BYTES. Which
> > in turn is currently set to 1024 on all supported architectures.
> > 
> > While testing ia64 I recently discovered that this value is
> > in fact too small. The particular setup I was using actually
> > needs 1172 bytes. This lead to very tedious failure mode
> > where the tail of one elf note would overwrite the head of
> > another if they ended up being alocated sequentially by kmalloc,
> > which was often the case.
> > 
> > It seems to me that a far better approach is to caclculate the size
> > that the area needs to be. This patch does just that.
> > 
> > If a simpler stop-gap patch for ia64 to be squeezed into 2.6.21(.X)
> > is needed then this should be as easy as making MAX_NOTE_BYTES
> > larger in arch/asm-ia64/kexec.h. Perhaps 2048 would be a good choice.
> > However, I think that the approach in this patch is a much more robust
> > idea.
> > 
> > Update I:
> > 
> >   Changed KEXEC_NOTE_HEAD_BYTES to KEXEC_NOTE_DESC_BYTES in line
> >   with the name of the relevant field in struct elf_note
> > 
> > Update II:
> > 
> >   * Use KEXEC_NOTE_NAME instead of "CORE" in kernel/kexec.c and
> >     arch/ia64/kernel/crash.c just to be extra sure that the data
> >     used to calculate the size, and the data stuffed into the reserved
> >     area is the same.
> > 
> >     Incidently, the ia64 code really ought to use the generic code.
> >     I am working on a patch for this. But it is not urgent.
> > 
> 
> Looks good. Another patch to make ia64 also use generic kexec code
> for note generation would be nice.

Thanks, I will make it so :-)

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

