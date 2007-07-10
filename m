Return-Path: <linux-kernel-owner+w=401wt.eu-S1762158AbXGJTtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158AbXGJTtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbXGJTtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:49:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:4650 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892AbXGJTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:49:13 -0400
Date: Tue, 10 Jul 2007 20:48:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dmitry Monakhov <dmonakhov@sw.ru>
cc: Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
In-Reply-To: <20070710175331.GA23173@dnb>
Message-ID: <Pine.LNX.4.64.0707102043090.2063@blonde.wat.veritas.com>
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
 <20070710175331.GA23173@dnb>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-893174385-1184096911=:2063"
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAA2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZG1vbmFraG92QHN3LnJ1AGplc0BzZ2kuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-893174385-1184096911=:2063
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 10 Jul 2007, Dmitry Monakhov wrote:
> On 18:27 =D0=92=D1=82=D1=80 10 =D0=98=D1=8E=D0=BB     , Hugh Dickins wrot=
e:
> > Or would this simpler patch be the right one?  I suspect the
> > mspec driver only says VM_LOCKED because of a deep-seated but
> > irrational fear that its pages might fall into reclaim.
> No mspec is not the only one :( , in my case it was fglrx (ati driver).

Ah, then fglrx is wrong too.  We don't want to check locked_vm,
but we don't much want it to wrap negative later.  Perhaps we
should mask VM_LOCKED off, perhaps we should BUG, perhaps we
should ask ATI/AMD to change it (a BUG would be persuasive ;)

> BTW: where is comment about it in do_mmap_pgoff: =20

Sorry, I don't understand.  You'd like a comment saying which flags
the driver may change and which it may not?  Hmmm... not today.

> =09/* Can addr have changed??
> =09 *
> =09 * Answer: Yes, several device drivers can do
> =09 * it in their
> =09 *         f_op->mmap method. -DaveM
> =09 */
> =09addr =3D vma->vm_start;
> =09pgoff =3D vma->vm_pgoff;
> =09vm_flags =3D vma->vm_flags;

Hugh
--8323584-893174385-1184096911=:2063--
