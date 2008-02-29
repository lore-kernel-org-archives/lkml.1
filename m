Return-Path: <linux-kernel-owner+w=401wt.eu-S933308AbYB2UED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308AbYB2UED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYB2UDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:03:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYB2UDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:03:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Qki3vv+tBct62bLvW/dBHFMzpk51/TeSt2MRCcxpqrInsjOLF/SsQ5msCGUbK0OlM
	6pXSw4x5TKNThTLb6KZoQ==
Message-ID: <65dd6fd50802291203g5c183b49mb2717e1cd9f691b5@mail.gmail.com>
Date: Fri, 29 Feb 2008 12:03:40 -0800
From: "Ollie Wild" <aaw@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Cc: "Jakub Jelinek" <jakub@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Michael Kerrisk" <michael.kerrisk@googlemail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802291128560.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204119455.6242.403.camel@lappy>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
	 <1204305488.6243.113.camel@lappy>
	 <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
	 <1204306934.6243.119.camel@lappy>
	 <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org>
	 <65dd6fd50802291101j3786ee60iec0f3a24f5df9945@mail.gmail.com>
	 <20080229190952.GM24887@devserv.devel.redhat.com>
	 <alpine.LFD.1.00.0802291128560.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 11:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Another thing we could decide to do is to just check the size of the stack
> that is left at the end of all the stack setup code, and just say "if it's
> less than X bytes, just return ENOMEM rather than set up a process with a
> really unusably small stack".

What would be a reasonable value, though?  Whereas argument space is
static and known at process execution time, required stack space is
program dependent.  If the program is going to crash, I'd rather it do
so at exec time.  Otherwise, we end up with corrupted files, partially
committed database transactions, and so forth.  I'd rather error on
the side of small argument space.

In the common situation, a 25% argument allocation is vastly larger
than the pre-2.6.23 limit.  We're really only talking about cases
where the limits have been set to unusually small values.  I'd be
interested in hearing from people that do this in practice.  Why do
they do this?  What are their expectations?

Ollie
