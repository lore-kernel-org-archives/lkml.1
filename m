Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGGXCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGGXCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYGGXBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:01:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:55418 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbYGGXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:01:50 -0400
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nathan Lynch <ntl@pobox.com>
Cc: Roland McGrath <roland@redhat.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080707221733.GJ9594@localdomain>
References: <20080703234140.GC9594@localdomain>
	 <20080704021929.5E9EF1541F5@magilla.localdomain>
	 <1215409693.8970.79.camel@pasglop>  <20080707221733.GJ9594@localdomain>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 09:00:38 +1000
Message-Id: <1215471638.8970.162.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 17:17 -0500, Nathan Lynch wrote:
> Benjamin Herrenschmidt wrote:
> > On Thu, 2008-07-03 at 19:19 -0700, Roland McGrath wrote:
> > > Why not just use ELF_HWCAP for this?  It looks like powerpc only has 3 bits
> > > left there (keeping it to 32), but 3 is not 0.  If not that, why not use
> > > dsocaps?  That is, some magic in the vDSO, which glibc already supports on
> > > all machines where it uses the vDSO.  (For how it works, see the use in
> > > arch/x86/vdso/vdso32/note.S for CONFIG_XEN.)
> > 
> > Well, we use strings to represent the platforms already (ie, the actual
> > CPU microarchitecture). Fitting those into bits would be annoying, it
> > makes sense to have AT_BASE_PLATFORM to be the "base" variant of
> > AT_PLATFORM.
> > 
> > _However_ there is a bug in that this patch adds an entry without
> > bumping the number of entries in the cached array (ie.
> > AT_VECTOR_SIZE_BASE needs to be updated).
> 
> Ugh, yes.  I was hoping to work this in such a way that AT_VECTOR_SIZE
> (and thus the size of mm_struct) increases only for architectures that
> implement AT_BASE_PLATFORM... would it be wrong to account for it in
> AT_VECTOR_SIZE_ARCH?

Yes. The later is for things added from ARCH_DLINFO. Since the
code for AT_BASE_PLATFORM is in the generic binfmt_elf, it would
be asking for trouble to not account for it in the base AT_VECTOR_SIZE.

Ben.


