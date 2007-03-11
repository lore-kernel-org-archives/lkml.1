Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbXCKKdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbXCKKdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXCKKdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:33:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXCKKdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:33:06 -0400
Date: Sun, 11 Mar 2007 11:32:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] KVM: MMU: Fix guest writes to nonpae pde
Message-ID: <20070311103250.GA23396@elte.hu>
References: <11736076283998-git-send-email-avi@qumranet.com> <11736076283297-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11736076283297-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> KVM shadow page tables are always in pae mode, regardless of the guest 
> setting.  This means that a guest pde (mapping 4MB of memory) is 
> mapped to two shadow pdes (mapping 2MB each).
> 
> When the guest writes to a pte or pde, we intercept the write and 
> emulate it. We also remove any shadowed mappings corresponding to the 
> write.  Since the mmu did not account for the doubling in the number 
> of pdes, it removed the wrong entry, resulting in a mismatch between 
> shadow page tables and guest page tables, followed shortly by guest 
> memory corruption.
> 
> This patch fixes the problem by detecting the special case of writing 
> to a non-pae pde and adjusting the address and number of shadow pdes 
> zapped accordingly.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>

tested this with both PAE and non-PAE Linux host and guest - works fine.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
