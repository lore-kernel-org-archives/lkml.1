Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXCDBuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXCDBuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXCDBuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:50:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:31448 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbXCDBuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:50:54 -0500
Date: Sat, 3 Mar 2007 17:50:31 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070304015031.GA4224@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228204144.GA32316@one.firstfloor.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 09:41:44PM +0100, Andi Kleen wrote:
> I suppose one could have a CONFIG_DEBUG_STACK_OVERFLOW that gets
> the stacks from vmalloc which would catch any overflow with its
> guard pages. This is you would need to change __pa() to handle
> that too because there might be still some drivers that do
> DMA on stack addresses.  Would be somewhat ugly but doable.
> But I have my doubts it is worth it again -- in my experience static
> analysis works well enough to trace them down and 
> there are not that many anyways.

In case anyone wants them, patches against v2.6.21-rc2-116-gbb648a0
for this are available from http://oss.oracle.com/~wli/stack_paranoia/

I only did arch/i386/ as per the Linux tradition, though I could
arrange for other arches easily enough, barring those for which I lack
target platforms. Testbooted on qemu -smp 4 with 64KB vmalloc()'d
stacks and IRQ stacks, compiletested in a couple of other configs.
Translation: very light testing. For me this was about reestablishing
reconnoiter of current mainline and familiarizing myself with qemu.

The patch series goes something like:
$ quilt series | xargs -i grep -nH '^Subj' patches/\{\} | cut -f2 -d/ |
cut -f 4 -d: | cat -n
     1   make stack size configurable
     2   add config option to vmalloc stacks
     3   make IRQ stacks independently configurable
     4   go BUG on vmallocspace in __pa()
     5   dynamically allocate IRQ stacks
     6   arrange for a guard page on cpu 0's IRQ stack

Chuck, is any of this of any use to you?


-- wli
