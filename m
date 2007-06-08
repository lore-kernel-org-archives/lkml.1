Return-Path: <linux-kernel-owner+w=401wt.eu-S1031884AbXFHTpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031884AbXFHTpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031959AbXFHTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:45:08 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38122 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031955AbXFHTpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:45:04 -0400
Date: Fri, 8 Jun 2007 15:44:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "Li, Xin B" <xin.b.li@intel.com>, kvm-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH] KVM - Fix rmode_tss_base declaration
Message-ID: <20070608194441.GA8169@c2.user-mode-linux.org>
References: <20070606191925.GA8989@c2.user-mode-linux.org> <B30DA1341B0CFA4893EF8A36B40B5C5D013A32CB@pdsmsx411.ccr.corp.intel.com> <20070607031103.GA12462@c2.user-mode-linux.org> <4667931C.8070007@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667931C.8070007@qumranet.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 08:09:48AM +0300, Avi Kivity wrote:
> Some extra logic is needed on i386 with >= 4GB.  Current code will
> wraparound since gfn_t is 32-bits long, but casting it to 64-bits is not
> the answer since the processor will truncate it back to 32 bits (the
> return value is eventually used as a long in enter_rmode()).

Is it necessary to initialize TR in enter_rmode?  I can't see anything
that says it has any meaning in real mode.

And if not, would not the guest be responsible for finding room for the
TSS?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
