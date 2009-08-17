Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZHQKGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZHQKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbZHQKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:06:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZHQKGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:06:36 -0400
Date: Mon, 17 Aug 2009 12:06:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] SFI: Simple Firmware Interface - v3
Message-ID: <20090817100628.GA21498@elte.hu>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250282295-25216-1-git-send-email-lenb@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> Changes since v2:
> 
>  re-based to v2.6.31-rc6
> 
>  included here some patches from the ACPI tree
>    that prepare for SFI
> 
>  deleted MMAP table parsing code
>    It isn't needed in the kernel, since on all known SFI boxes today,
>    the booter parses this table for us.
> 
>  fixed some build issues, generally related to CONFIG_ACPI=n
> 
>  various cosmetic changes in response to v2 code review
> 
> What is left to do:
> 
>  x86_32 can set CONFIG_PCI_MMCONFIG=y when
>  SFI=y and ACPI=n, but x86_64 can not, yet.
> 
>  A number of drivers will use SFI and will provide
>  their own table parsers, but those will come later.

Ok, this iteration is even nicer.

  Reviewed-by: Ingo Molnar <mingo@elte.hu>

A patch technical request/suggestion. I guess you'd like to keep 
these bits in the ACPI tree, so that you can test it and merge it 
with ongoing ACPI changes, right?

That would be fine to me for all the arch/x86/ touching patches, 
except for this one:

 [PATCH 05/11] ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n

I'd like to pick this one up into tip:x86/apic, because there's 
ongoing work in this area. (also, by the looks of it, i'd not be 
surprised if this patch needed some testing. This is fragile code 
with quirky Kconfig dependencies.)

I can create a standalone topic for this (based on .31-rc6), 
containing this single commit, which you could pull into the ACPI 
tree? That way we both can have this commit and nobody is held up, 
and both trees can be pushed to Linus in the .32 merge window, 
independently of each other.

	Ingo
