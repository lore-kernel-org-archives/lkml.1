Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZKWVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZKWVKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZKWVKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZKWVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:10:31 -0500
Date: Mon, 23 Nov 2009 19:09:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
	perf tools
Message-ID: <20091123210939.GD15547@ghostprotocols.net>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com> <1258987355-8751-4-git-send-email-fweisbec@gmail.com> <20091123173601.GA7273@in.ibm.com> <20091123202525.GA4979@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123202525.GA4979@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 23, 2009 at 09:25:28PM +0100, Frederic Weisbecker escreveu:
> On Mon, Nov 23, 2009 at 11:06:01PM +0530, K.Prasad wrote:
> > With kernel symbols as input it would be possible to derive the bkpt
> > length based on the symbol-size, say using kallsyms_lookup_size_offset()
> > (although the corresponding length may not be available on the host
> > processor such requests can be failed or over-ridden by the user using
> > a smaller length), but for addresses I think it is vital to know what
> > breakpoint length is desired by the user.
 
> Yeah. I guess we first need a way to manually add this length, may be:

> 	mem:addr/len:access
 
> And as you said, finding it automatically for symbols. But still,
> passing symbols to perf attr leads to confusion and complexity if we
> want to profile in userspace.
 
> I think we should find this symbol length from userspace. I'm not sure
> how yet, probably using Dwarf. Arnaldo, do you have an idea about that?

DWARF has the type for each variable or struct member, getting its size
is straightforward.

Using just /proc/kallsyms all we can do is find the size of a variable
by looking at its address and the address of the next one.

- Arnaldo
