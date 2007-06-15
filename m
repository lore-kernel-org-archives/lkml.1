Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbXFONA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbXFONA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbXFONAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:00:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36760 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbXFONAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:00:49 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>, David Howells <dhowells@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070615135420.7fe2e4c1@the-village.bc.nu>
References: <200706151355.57464.ak@suse.de>
	 <200706151131.38429.arnd@arndb.de> <5717.1181909357@redhat.com>
	 <200706151443.13511.ak@suse.de> <20070615135420.7fe2e4c1@the-village.bc.nu>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 14:00:06 +0100
Message-Id: <1181912406.25228.491.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:54 +0100, Alan Cox wrote:
> For the parts used by the processors in question yes people have done
> that work so using the types without unaligned.

I still think we could use a 'get_maybe_but_probably_not_unaligned()',
although it could have a better name.

People now use get_unaligned() for two reasons -- firstly because we
_expect_ something to be unaligned, and we get a performance improvement
if we just emit code to directly handle that instead of taking the trap.
And more recently we've also started to use it because there's a
_slight_ chance it could be unaligned, and some architectures can't
cope.

Where the unalignment is possible but unlikely, many architectures
probably shouldn't be emitting code to cope with it; they should just
take the trap in the rare case.

In fact, the probability threshold at which it makes sense to just take
the trap will vary from architecture to architecture. We should probably
just have a get_probably_unaligned(...) macro which has its first arg as
an _estimated_ constant probability. Then the architecture code could
emit what it likes according to the probability.

-- 
dwmw2

