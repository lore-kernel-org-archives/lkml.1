Return-Path: <linux-kernel-owner+w=401wt.eu-S1030989AbXD1Gkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030989AbXD1Gkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161359AbXD1Gkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:40:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53446 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030989AbXD1GkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:40:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org>
	<m1zm4tghyf.fsf@ebiederm.dsl.xmission.com> <4632E9F1.8020407@goop.org>
Date: Sat, 28 Apr 2007 00:39:22 -0600
In-Reply-To: <4632E9F1.8020407@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 27 Apr 2007 23:30:09 -0700")
Message-ID: <m1odl9gfz9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I don't have any particularly bright ideas, but there is the other idea
> I mentioned.  I could pre-initialize the pagetable with the Xen
> template, but use unconditional calls to set_pte in pagetable_init. 
> However, the init-time xen_set_pte simply refuse to set _PAGE_WRITE on a
> pte which isn't already writable, thereby protecting the RO state of the
> pagetable pages.  Once pagetable construction has finished, it would
> switch to the real xen_set_pte, which operates as normal.
>
> This has the downside of making init-time xen_set_pte a little strange,
> but it does have the advantage of making the Xen constraints solely the
> responsibility of the Xen code, and it is mitigated by the fact that it
> is only in effect during pagetable_init.
>
> Would that work for everyone?

For a short term solution it sounds reasonable.

Eric
