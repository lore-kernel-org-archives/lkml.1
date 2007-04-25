Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXDYW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXDYW17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXDYW17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:27:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41614 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422813AbXDYW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:27:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
	<20070425044813.f83dde4e.akpm@linux-foundation.org>
	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
	<462FD179.6070802@goop.org>
Date: Wed, 25 Apr 2007 16:27:01 -0600
In-Reply-To: <462FD179.6070802@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 15:08:57 -0700")
Message-ID: <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Nope.  It's not overwriting anything.
>
> This should fix it.
>
> Subject: x86: fix PSE pagetable construction
>
> When constructing the initial pagetable in pagetable_init, make sure
> that non-PSE pmds are updated to PSE ones.
>
> This moves the definition of pmd_huge() out of the hugetlbfs files
> into pgtable.h.

No.  Please just remove the conditionals on the leaf pages.
We know exactly what we require them to be, there is minimal
cost and no downside to just setting the pte entries to
what we want them to be for the identity mapping.

It doesn't make sense for paravirtualization or anything else to 
influence that.

This may be redoing work that has been done before but it is
doing it all one common place.

It does make sense not to overwrite the intermediate pages.

Not overwriting intermediate pages is reasonable, and allows
other things to be going on and to be preserved.

Eric
