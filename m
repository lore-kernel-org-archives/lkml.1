Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbXHXDtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbXHXDtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 23:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXHXDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 23:49:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40573 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbXHXDtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 23:49:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, samuel@sortiz.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - irda goes belly up
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
Date: Thu, 23 Aug 2007 21:46:44 -0600
In-Reply-To: <20070823141652.d488a6e0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 23 Aug 2007 14:16:52 -0700")
Message-ID: <m11wdtoaqj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Yes, the ENOMEM is bogus.  But irda_sysctl_register() saw a NULL return
> from register_sysctl_table() and simply has no clue why it failed, and is
> forced to assume ENOMEM.  That's a design shortcoming in
> register_sysctl_table(), whcih should have returned an ERR_PTR.  Doesn't
> matter much.

I should say something about the return value issue.

Currently the only time this matters is when someone messes up in
development, and if it isn't an out of memory error we get messages in
dmesg so it shouldn't be to hard to sort out.

I agree it is a bit of a short coming that we can only return NULL
and it might be worth changing that at some point.  Perhaps when
I introduce register_sysctl_path would be a good time.   Going
through all of the callers just to give a better return value when
they can't do anything about it anyway seems to be a lot of work
for a very minor improvement.

Eric
