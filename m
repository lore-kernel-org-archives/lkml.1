Return-Path: <linux-kernel-owner+w=401wt.eu-S2992923AbXDYTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992923AbXDYTC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXDYTC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:02:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37500 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992923AbXDYTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:02:25 -0400
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
	<462F9B64.3020107@goop.org>
Date: Wed, 25 Apr 2007 13:01:19 -0600
In-Reply-To: <462F9B64.3020107@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 11:18:12 -0700")
Message-ID: <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I might have introduced it as part of the paravirt_ops patches.  When
> setting up pagetables under Xen, we need to make sure we preserve the
> initial mappings Xen put in place (it starts the VM with paging enabled,
> and a sane initial pagetable).  This may have leaked over into native if
> it doesn't replace an existing entry.

Yes in paravirt_ops-hooks-to-set-up-initial-pagetable
Grr.  That is what I get for trying to avoid conflicts by working
against the -mm tree.

I thought that code had been like that for a while.  Since it hasn't
been merged upstream it looks to me like that patch needs to be fixed.
And we can keep HPA debugging patch.

> Hm, but it should be overwriting small mappings with large ones.  Maybe
> I overlooked that.

Nope.  It's not overwriting anything.  I'm not at all convinced we
should preserve the Xen sillyness.  I'm not exactly against it,
but it adds complexity to already complex code.

>> I'm halfway through putting together a patchset to address a
>> bunch of these.
>>
>> I haven't yet resolved how I want to allocate the pages for the
>> identity mapping of the page table yet.  I can't use the bootmem
>> allocate as it exists because that assumes the page is mapped
>> into the address space already.
>>   
>
> Are you going to clash horribly with the paravirt pagetable setup?  We
> should probably coordinate if so.

We will have to see.  Currently the paravirt pagetable setup clashes
horrible with actually running a kernel on real hardware.

Color me not impressed by the paravirt mess.

Eric
