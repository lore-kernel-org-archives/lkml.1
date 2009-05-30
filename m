Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZE3XUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZE3XUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZE3XUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:20:42 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:59745 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZE3XUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:20:42 -0400
Date: Sat, 30 May 2009 16:18:13 -0700
From: "Larry H." <research@subreption.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530231813.GP6535@oblivion.subreption.com>
References: <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com> <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com> <20090530213311.GM6535@oblivion.subreption.com> <20090531001318.093e3665@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090531001318.093e3665@lxorguk.ukuu.org.uk>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:13 Sun 31 May     , Alan Cox wrote:
> > I was pointing out that the 'those test and jump/call branches have
> > performance hits' argument, while nonsensical, applies to kzfree and
> > with even more negative connotations (deeper call depth, more test
> > branches used in ksize and kfree, lack of pointer validation).
> 
> But they only apply to kzfree - there isn't a cost to anyone else. You've
> move the decision to compile time which for the fast path stuff when you
> just want to clear keys and other oddments is a big win.

OK, I'm going to squeeze some time and provide patches that perform the
same my original page bit ones did, but using kzfree. Behold code like
in the tty buffer management, which uses the page allocator directly for
allocations greater than PAGE_SIZE in length. That needs special
treatment, and is exactly the reason I've proposed unconditional
sanitization since the original patches were rejected.

	Larry

