Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbYGOTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbYGOTnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYGOTnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:43:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYGOTm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:42:59 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 15 Jul 2008 15:41:31 -0400
In-Reply-To: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain> (James Bottomley's message of "Tue, 15 Jul 2008 13:33:22 -0500")
Message-ID: <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> One of the big nasties of systemtap is the way it tries to embed
> virtually the entirety of the kernel symbol table in the probe
> modules it constructs.

It is a compromise of conflicting requirements. 

> This is highly undesirable because it represents a subversion of the
> kernel API to gain access to unexported symbols.

Please elaborate.  Does the translator or its runtime use unexported
symbols?  (That would arouse the question about why.)

Or are you talking about being able to *probe* unexported functions or
access unexported data?  That would be a deliberate feature.

> At least for kprobes, the correct way to do this is to specify the
> probe point by symbol and offset.

But there won't be just kprobes.  Much of this code was built with
anticipation of user-space probing, and there the kernel won't have a
similar mechanism.  Similarly, the code is written to work with old
kernels too - ones that predate the symbol+offset kprobe API.

Unless someone is about to rip out pure address-based kprobes, I see
no reason to complicate the code.


- FChE
