Return-Path: <linux-kernel-owner+w=401wt.eu-S1946723AbXD3T32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946723AbXD3T32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946724AbXD3T32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:29:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61685 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946723AbXD3T30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:29:26 -0400
Date: Mon, 30 Apr 2007 12:26:02 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [4/6] go BUG on vmallocspace in __pa() (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430192602.GD26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174510.GG19966@holomorphy.com> <20070430185242.GB11512@one.firstfloor.org> <20070430202059.4db688d3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430202059.4db688d3@the-village.bc.nu>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
>>>> Here's what I did for i386 for someone concerned about blowing the
>>>> stack.

On Mon, Apr 30, 2007 at 10:45:10AM -0700, William Lee Irwin III wrote:
>>> Add checks to __pa() so it goes BUG() on vmallocspace addresses.

On Mon, 30 Apr 2007 20:52:42 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>> Sorry I think that's too costly to do. __pa is pretty common

On Mon, Apr 30, 2007 at 08:20:59PM +0100, Alan Cox wrote:
> But not too costly to do if it is done solely with vmalloc the stack
> for
> debug purposes. The bigger problem with the vmalloc approach is there
> are
> still offenders who DMA off the kernel stack on i386 although I'd hope
> they are all ancient... we'll find out with this anyway

Sorry about the email address switch. This is actually work-related.

The stack vmalloc() and __pa() patches were partially intended to catch
or otherwise deliberately break such offenders and go BUG() on them. The
__pa() check in particular is exclusively for the purpose of catching
them. The primary motive being the stack vmalloc() patches remained, of
course, establishing a guard page to trap stack overflows.


-- wli
