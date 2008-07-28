Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYG1JK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYG1JK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYG1JKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:10:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40160 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbYG1JKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:10:50 -0400
X-Sasl-enc: 2zgshmCBC3cqCmdNBCDa8GQLb/+ZiBsHNpgv2DMPOluZ 1217236249
Message-ID: <488D8D16.7010502@ladisch.de>
Date: Mon, 28 Jul 2008 11:10:46 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: lkml <linux-kernel@vger.kernel.org>, bob.picco@hp.com,
       venkatesh.pallipadi@intel.com, Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 2.6.26-git] /dev/hpet - fixes and cleanup
References: <200807221508.56672.david-b@pacbell.net> <200807251258.59878.david-b@pacbell.net> <488D7BFF.10005@ladisch.de> <200807280127.22060.david-b@pacbell.net>
In-Reply-To: <200807280127.22060.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Oh ... I see.  It's called write_counter() but doesn't
> actually write the counter.  Likewise, read_counter() is
> not actually reading the counter.  Gaack ...

A more correct name would be something like
write_a_register_that_has_the_same_size_as_a_counter_register().

> In fact, most places would be better off just hard-wiring 32-bit
> access...

... and the definition of read/write_counter() depends on the word size
of the CPU architecture and has nothing to do with the actual size of
the HPET registers ...

I'm hoping that I can deprecate and delete much of this code without
having to clean it up first.

> Any comments on the rest?

Looks fine.  I would have preferred a series of smaller patches, but my
feelings on this are not strong enough to split it myself or to ask you
to do it.


Regards,
Clemens
