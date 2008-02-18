Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbYBRM1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbYBRM1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYBRM1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:27:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYBRM1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:27:46 -0500
To: David Miller <davem@davemloft.net>
Cc: tilman@imap.cc, bunk@kernel.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Unable to continue testing of 2.6.25
From: Andi Kleen <andi@firstfloor.org>
References: <200802171025.30590.elendil@planet.nl>
	<20080217131611.GA1403@cs181133002.pp.htv.fi>
	<47B88A08.2070902@imap.cc>
	<20080217.183330.34203930.davem@davemloft.net>
Date: Mon, 18 Feb 2008 13:27:45 +0100
In-Reply-To: <20080217.183330.34203930.davem@davemloft.net> (David Miller's message of "Sun\, 17 Feb 2008 18\:33\:30 -0800 \(PST\)")
Message-ID: <p73r6faxxdq.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Tilman Schmidt <tilman@imap.cc>
> Date: Sun, 17 Feb 2008 20:24:56 +0100
>
>> No, that's not the real problem. Even if the kernel didn't lack
>> any required functionality and it could all be done today without
>> VirtualBox, pulling the rug from underneath it like that leaves
>> all those who are currently relying on it without the ability to
>> continue testing newer kernels until they find the time to redesign
>> their working environment.
>
> No, it is VirtualBox's problem.  Nobody outside of the kernel
> should be using that symbol, 

> it can only be used for totally
> unsupportable things as far as upstream is concerned.

Creating any uncacheable or write protected mappings in unsupportable? 
I suspect you would have a hard time actually justifying this. That's
a relatively common and useful operation in device drivers.

The only special case I would agree with you is doing write-combined
mappings using this which is indeed generally unsupported yet on x86
before the full PAT infrastructure goes in (but 
I cannot imagine VirtualBox would use WC for anything) 

Most likely if they just want to write protect something
they should either use the new interface or just open code
it using lookup_address() / change ptes / flush tlbs.

-Andi

