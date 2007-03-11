Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXCKKef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXCKKef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXCKKeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbXCKKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:34:12 -0400
Date: Sun, 11 Mar 2007 11:33:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram
Message-ID: <20070311103334.GB23396@elte.hu>
References: <11736076283998-git-send-email-avi@qumranet.com> <11736076282800-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11736076282800-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> PAGE_MASK is an unsigned long, so using it to mask physical addresses 
> on i386 (which are 64-bit wide) leads to truncation.  This can result 
> in page->private of unrelated memory pages being modified, with 
> disasterous results.
> 
> Fix by not using PAGE_MASK for physical addresses; instead calculate 
> the correct value directly from PAGE_SIZE.  Also fix a similar 
> BUG_ON().
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>

i have tested this, albeit with less than 4GB RAM.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
