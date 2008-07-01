Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbYGATu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbYGATu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYGATuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:50:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYGATuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:50:18 -0400
Date: Tue, 1 Jul 2008 21:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Simple changes to make traps_32.c and traps_64.c
	more similar
Message-ID: <20080701195004.GA27557@elte.hu>
References: <20080701193643.GA29695@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Tiny first step at unification of traps_32.c and traps_64.c. All
> changes are meant to be trivial.
>  - mostly whitespace changes
>  - chose one of obviously equivalent pieces of code:
> 	 - reordering of declarations
> 	 - simple renaming of local variables
> 	 - if (cond) { ... } -> if (!cond) goto end_of_block ...
> 	 - local caching of current, cpu, etc...
> 
> This makes the diff between traps_32.c and traps_64.c smaller:
> 
> from:
>   1474  +++++++++++++++++++++++++++++--------------------------------
>   1 file changed, 722 insertions(+), 752 deletions(-)
>   
> to:
>   1052  +++++++++++++++++++++++++++++--------------------------------
>   1 file changed, 512 insertions(+), 540 deletions(-)

nice. In terms of functionality, it is supposed to be a pure 
no-changes-intended commit, correct?

In that case it makes sense to split it in two: in the first (larger) 
bit put the things that are provably invariant on the .o and can be 
verified that way.

In the second one, put the things that change the .o output slightly 
(variable reordering can do that) - this we have to check more closely.

(One can normally do such a splitup by editing the raw diff and 
splitting it in half that way - by sorting each chunk into the 
appropriate target patch - and then making sure the end result is still 
the same.)

	Ingo
