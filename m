Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYJAAo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYJAAo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYJAAoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:44:20 -0400
Received: from ozlabs.org ([203.10.76.45]:43450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYJAAoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:44:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Date: Wed, 1 Oct 2008 10:44:13 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <48E2506C.7000406@sgi.com> <alpine.LFD.2.00.0809300939450.3389@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809300939450.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011044.14148.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2008 02:46:59 Linus Torvalds wrote:
> Quite frankly, I personally do hate typedefs that end up being pointers,
> and used as pointers, without showing that in the source code.
...
> I'm now a bit more leery about this whole thing just
> because the typedef ends up hiding so much - it doesn't just hide the
> basic type, it hides a very basic *code* issue.

Yes, this is why my version of the rework moved away from typedefs, except for 
the special case of "cpumask_var_t" for stack vars where this trick is really 
desired.

Everywhere else, the code becomes nice and clear: struct cpumask *.

Cheers,
Rusty.
