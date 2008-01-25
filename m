Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbYAYVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbYAYVmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYAYVmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:42:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbYAYVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:42:05 -0500
Message-ID: <479A5689.80505@zytor.com>
Date: Fri, 25 Jan 2008 13:37:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <c084def0f6afb2b2ef47.1201296200@localhost>
In-Reply-To: <c084def0f6afb2b2ef47.1201296200@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> PAE mode requires that we reload cr3 in order to guarantee that
> changes to the pgd will be noticed by the processor.  This means that
> in principle pud_clear needs to reload cr3 every time.  However,
> because reloading cr3 implies a tlb flush, we want to avoid it where
> possible.

It only matters (for a processor which supports PGE) if we actually use 
the namespace in between.

> In huge_pmd_unshare, it is followed by flush_tlb_range, which always
> results in a full cr3-reload tlb flush.

This one makes me nervous, as it feels like a side effect of 
implementation, and not a guarantee by design.

	-hpa
