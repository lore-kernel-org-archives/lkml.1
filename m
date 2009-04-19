Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbZDSN5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbZDSN5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZDSN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:57:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbZDSN5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:57:25 -0400
Date: Sun, 19 Apr 2009 15:56:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rakib.mullick@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix false positive section mismatch
	warnings in the apic code
Message-ID: <20090419135639.GA28919@elte.hu>
References: <b9df5fa10904181941u4a73fc97i80dfa90a50b8daf5@mail.gmail.com> <tip-aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7@git.kernel.org> <49EAF31C.8020108@gmail.com> <20090419095759.GA4808@elte.hu> <49EAFACD.6040302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EAFACD.6040302@gmail.com>
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Ingo Molnar wrote:
> > * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > 
> >> tip-bot for Rakib Mullick pisze:
> >>> Commit-ID:  aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> >>> Gitweb:     http://git.kernel.org/tip/aa57a15ad17d284e62fbd24cf7e0eb628b2cb3f7
> >>> Author:     Rakib Mullick <rakib.mullick@gmail.com>
> >>> AuthorDate: Sun, 19 Apr 2009 08:41:17 +0600
> >>> Committer:  Ingo Molnar <mingo@elte.hu>
> >>> CommitDate: Sun, 19 Apr 2009 11:28:18 +0200
> >>>
> >>> x86: Fix false positive section mismatch warnings in the apic code
> >>>
> >>> find_unisys_acpi_oem_table() and unmap_unisys_acpi_oem_table() 
> >>> are non init functions, but these functions calls some init 
> >>> functions. But we need these functions as non-init functions.
> >> Why? This warning seems to be valid.
> > 
> > It's put into struct apic::acpi_madt_oem_check - which is a 
> > non-init structure. That particular field is only used from init 
> > context - but other fields are used all the time.
> 
> Can we have a rule that "every __ref usage should have a comment 
> explaining why __ref is safe in this place"?

Yes, that's prudent.

	Ingo
