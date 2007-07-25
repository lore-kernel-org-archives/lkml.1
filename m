Return-Path: <linux-kernel-owner+w=401wt.eu-S934221AbXGYS0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbXGYS0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbXGYSZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:25:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665AbXGYSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:25:51 -0400
Date: Wed, 25 Jul 2007 11:24:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hpa@zytor.com,
       kaos@ocs.com.au, xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
In-Reply-To: <20070725171956.GF27237@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.999.0707251122300.3607@woody.linux-foundation.org>
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com>
 <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net>
 <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
 <20070725171956.GF27237@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2007, Al Viro wrote:
> 
> Umm...  Actually, we might be able to do something like
> {
> 	l: __builtin_trap();
> 	static struct ... v __attribute__((section(...))) = { &&l, n, file };

No.

A C-level label is a pointer to a C-level construct.

The compiler may have reasons to put other instructions in between the 
label and the final end result of the __builtin_trap. The above may work 
for some trivial test-case, but in the end, the label and the __builtin 
are *not* atomic, and the compiler may well end up having register spills 
etc in there, or having CSE'd two traps, or any number of details meaning 
that the label doesn't point to the exact ud2 instruction.

			Linus
