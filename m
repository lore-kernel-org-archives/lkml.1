Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbXCEWBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbXCEWBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXCEWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:01:46 -0500
Received: from gw.goop.org ([64.81.55.164]:47699 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXCEWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:01:45 -0500
Message-ID: <45EC9347.9030009@goop.org>
Date: Mon, 05 Mar 2007 14:01:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305215838.051CD1800E5@magilla.sf.frob.com>
In-Reply-To: <20070305215838.051CD1800E5@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> Does the old userland compatibility you're concerned about really need the
> vdso to be at 0xfffffe000 in particular, or just need it to be at a fixed
> address that matches the phdrs inside the image?  My recollection of the old
> glibc's limitation was that it expected the image's phdrs to match its load
> address.  The xen kernels used to change this to 0xffffd000 or something,
> and AFAIK that was fine.  If that's all that's needed, it is not so hard to
> adjust the vDSO contents at boot time (phdrs, shdrs, and symbols; no code
> contents use the absolute address).  Under CONFIG_COMPAT_VDSO, it can see
> where the paravirt moved the fixmap to, and apply adjustments.
>   

Jan Beulich just posted a patch to do just this - relocate the vdso's
ELF header.  If that's all that's really required to keep COMPAT_VDSO
viable under PARAVIRT, then it seems like the way to go.

    J
