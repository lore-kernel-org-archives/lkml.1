Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbYGGWRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbYGGWRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYGGWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:17:47 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:37969 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbYGGWRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:17:46 -0400
Date: Mon, 7 Jul 2008 17:17:33 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland McGrath <roland@redhat.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
Message-ID: <20080707221733.GJ9594@localdomain>
References: <20080703234140.GC9594@localdomain>
 <20080704021929.5E9EF1541F5@magilla.localdomain>
 <1215409693.8970.79.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215409693.8970.79.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 857C2392-4C72-11DD-9270-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2008-07-03 at 19:19 -0700, Roland McGrath wrote:
> > Why not just use ELF_HWCAP for this?  It looks like powerpc only has 3 bits
> > left there (keeping it to 32), but 3 is not 0.  If not that, why not use
> > dsocaps?  That is, some magic in the vDSO, which glibc already supports on
> > all machines where it uses the vDSO.  (For how it works, see the use in
> > arch/x86/vdso/vdso32/note.S for CONFIG_XEN.)
> 
> Well, we use strings to represent the platforms already (ie, the actual
> CPU microarchitecture). Fitting those into bits would be annoying, it
> makes sense to have AT_BASE_PLATFORM to be the "base" variant of
> AT_PLATFORM.
> 
> _However_ there is a bug in that this patch adds an entry without
> bumping the number of entries in the cached array (ie.
> AT_VECTOR_SIZE_BASE needs to be updated).

Ugh, yes.  I was hoping to work this in such a way that AT_VECTOR_SIZE
(and thus the size of mm_struct) increases only for architectures that
implement AT_BASE_PLATFORM... would it be wrong to account for it in
AT_VECTOR_SIZE_ARCH?
