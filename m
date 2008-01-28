Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbYA1O4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbYA1O4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYA1O4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:56:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:55088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYA1O4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:56:23 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 1/3] x86: a new API for drivers/etc to control cache and other page attributes
From: Andi Kleen <andi@firstfloor.org>
References: <20080125144937.2709f9ae@laptopd505.fenrus.org>
Date: Mon, 28 Jan 2008 15:56:21 +0100
In-Reply-To: <20080125144937.2709f9ae@laptopd505.fenrus.org> (Arjan van de Ven's message of "Fri\, 25 Jan 2008 14\:49\:37 -0800")
Message-ID: <p733asi80dm.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> Right now, if drivers or other code want to change, say, a cache attribute of a
> page, the only API they have is change_page_attr(). c-p-a is a really bad API
> for this, because it forces the caller to know *ALL* the attributes he wants
> for the page, not just the 1 thing he wants to change. So code that wants to
> set a page uncachable, needs to be aware of the NX status as well etc etc etc.

Please think clearly through the various cases.

NX for areas which can be legitimately non NX (very few) is 100%
transparently handled in c_p_a() no matter what the caller passes in.

For DEBUG_PAGEALLOC it is similar. While it can make kernel pages
ro these should be only free pages and what business has anybody changing
attributes on arbitary free pages? No it is just a bug.

So if you look closely at the various cases there is no legitimate
reason to ever use anything other than the standard PAGE_KERNEL_*
defines with change_page_attr()

The only exception I know of is the cpa selftest which can change
attributes of arbitrary pages, but that one does a lookup_address on
its own anyways.

You basically solved a non-issue here.

-Andi
