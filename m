Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXFTXCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXFTXCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXFTXCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:02:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:22737 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXFTXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:02:42 -0400
Message-ID: <5640c7e00706201602g5c983a34qf7644b19d6295d42@mail.gmail.com>
Date: Thu, 21 Jun 2007 11:02:42 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, "Ingo Molnar" <mingo@elte.hu>,
       "Darrick J. Wong" <djwong@us.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Bj?rn Steinbrink" <B.Steinbrink@gmx.de>,
       "William Cohen" <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       "Antonino Daplas" <adaplas@gmail.com>, "Olaf Hering" <olaf@aepfle.de>,
       "Ville Syrj?l?" <syrjala@sci.fi>, "Jean Delvare" <khali@linux-fr.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Soeren Sonnenburg" <kernel@nn7.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
	 <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> And yes, sometimes debugging *does* change what it debugs. In timing, if
> nothing else, but also in the kinds of things you can do.

Totally agree.

> For example, we
> don't allow slab redzoning on data structures that have alignment
> restrictions not compatible with the redzoning, and I'd argue that this is
> more of the same: we just should not do DEBUG_RODATA if you expect to
> change read-only data.
>

Well the description for DEBUG_RODATA is:
         Mark the kernel read-only data as write-protected in the pagetables,
         in order to catch accidental (and incorrect) writes to such const data.

What we are doing with kprobes is neither accidental, nor incorrect.

> There's just no *point*.
>
>                 Linus
>
I understand your philosophical viewpoint here. Anyway it's no biggie
as can keep the patch out of tree if I want it... Another option is to
be able to enable and disable protecting read only data via a sysctl
but that seems even uglier.

Anyway I'll stop wasting your time now.

Ian
-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
