Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJ3JUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJ3JUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYJ3JTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:19:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:53016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYJ3JTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:19:53 -0400
From: Andreas Schwab <schwab@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@ver.kernel.org
Subject: Re: [PATCH] Fix hid_device_id for cross compiling
References: <jevdvgl345.fsf@sykes.suse.de>
	<20081030002332.4ef1fac4.akpm@linux-foundation.org>
X-Yow: I hope something GOOD came in the mail today so I have
 a REASON to live!!
Date: Thu, 30 Oct 2008 10:19:51 +0100
In-Reply-To: <20081030002332.4ef1fac4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 30 Oct 2008 00:23:32 -0700")
Message-ID: <jehc6u8mo8.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 26 Oct 2008 00:30:18 +0200 Andreas Schwab <schwab@suse.de> wrote:
>
>> struct hid_device_id contains hidden padding which is bad for cross
>> compiling.  Make the padding explicit and consistent across
>> architectures.
>> 
>
> What is "bad" about it?

It is bad because it depends on the alignment restrictions of the
architecture.  On m68k everything is aligned on a 2-byte boundary, so
this padding does not exist.

> Can you expand a bit on the problem which is being fixed here?

It's the well known cross compiling problem with modpost that has bitten
us so often before.  This one is even worse, because modpost would
silently read bogus values since the struct size is the same, only the
padding moves elsewhere.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
