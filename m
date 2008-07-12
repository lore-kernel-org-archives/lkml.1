Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYGLHi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYGLHi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYGLHiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:38:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:48396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbYGLHiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:38:19 -0400
Subject: Re: Multiple MSI, take 4
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       jbarnes@virtuousgeek.org, rdunlap@xenotime.net, mtk.manpages@gmail.com
In-Reply-To: <20080711211559.GV14894@parisc-linux.org>
References: <20080711211559.GV14894@parisc-linux.org>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 17:37:20 +1000
Message-Id: <1215848240.7549.168.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 15:16 -0600, Matthew Wilcox wrote:
> Here we go with take 4.  Changes:
> 
>  - Check the requested number of interrupts against the maximum number
>    the device claims to support.  Thanks to Hidetoshi Seto for pointing
>    out this oversight.
>  - Implemented Eric's suggestion of using a single IRQ and storing the
>    data with it.
>  - As a result, don't try to support the mode in the AHCI driver where
>    the excess ports all share the last interrupt.  It could be done, but
>    it would be rather messy and I don't have hardware that supports that
>    mode anyway.
> 
> I'm fairly comfortable with the subchannel notion we're introducing
> here.  It's more flexible than MSI and doesn't impose a penalty on
> architectures which don't implement it.  It makes some things more
> complex, but it makes other things simpler, so I think it's a wash from
> a cleanliness standpoint.

I prefer you initial approach. If those are effectively one interrupt,
you end up with the whole IRQ_INPROGRESS logic going bonkers trying to
prevent them from occuring at the same time and possibly losing some.

I think the masking "issue" is mostly a non-issue as I explained in
other emails.

Cheers,
Ben.


