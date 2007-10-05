Return-Path: <linux-kernel-owner+w=401wt.eu-S1764360AbXJEVYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764360AbXJEVYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbXJEVYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:24:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbXJEVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:24:30 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, satyam@infradead.org,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
References: <20070918194647.GA23800@gollum.tnic>
	<20071005124705.6584e2f9.akpm@linux-foundation.org>
	<4706A20A.5060603@goop.org>
	<20071005140050.655b7727.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>
X-Yow: I want to kill everyone here with a cute colorful Hydrogen Bomb!!
Date: Fri, 05 Oct 2007 23:24:25 +0200
In-Reply-To: <Pine.LNX.4.64.0710051701530.12079@localhost.localdomain> (Robert
	P. J. Day's message of "Fri\, 5 Oct 2007 17\:03\:28 -0400 \(EDT\)")
Message-ID: <jeve9lmf06.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> On Fri, 5 Oct 2007, Andrew Morton wrote:
>
>> -#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
>> +#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>
> or you could take advantage of the macros in kernel.h and write that
> as:
>
> +#define DMA_BIT_MASK(n)      (((n) == 64) ? ULLONG_MAX : ((1ULL<<(n))-1))

#define DMA_BIT_MASK(n)         ((u64)-1 >> (64 - (n)))

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
