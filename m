Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYH1USZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYH1USZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYH1USR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:18:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYH1USQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:18:16 -0400
Date: Thu, 28 Aug 2008 22:17:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] resource/x86: add sticky resource type
Message-ID: <20080828201758.GA18437@elte.hu>
References: <1219888583-31577-1-git-send-email-yhlu.kernel@gmail.com> <20080828082119.GN21875@elte.hu> <alpine.LFD.1.10.0808281015440.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808281015440.3300@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The fact is, the only reliable way to handle these things has _always_ 
> been to ask the hardware first. Add the broken resources from ACPI and 
> other BIOS tables _later_. If they conflict, it is the ACPI/BIOS 
> tables that should be removed.

i fully agree with that principle, i just messed up implementing it.

'Sticky resources' tried to be exactly the kind of 'untrusted, possibly 
wrong' resources, which should not prevent existing PCI resources from 
being registered - they would at most prevent new PCI resources from 
being allocated over them. (the free space is large enough for us to 
take the small/untrusted hint from the BIOS where not to allocate to)

I missed the possibility of a sticky resource not being wide enough and 
preventing a BAR from being registered, due to partial overlap. That was 
not intended.

I guess this whole patchset has to become a lot wider and a lot more 
involved.

	Ingo
