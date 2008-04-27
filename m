Return-Path: <linux-kernel-owner+w=401wt.eu-S1765014AbYD0XEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765014AbYD0XEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYD0XEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:04:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbYD0XEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:04:34 -0400
Message-ID: <48150667.90806@zytor.com>
Date: Sun, 27 Apr 2008 16:04:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <4815009C.2010809@garzik.org>	<20080427.154620.177583216.davem@davemloft.net>	<48150392.6040508@zytor.com> <20080427.155834.189904598.davem@davemloft.net>
In-Reply-To: <20080427.155834.189904598.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I think this is a reasonable course of action.
> 
> That leaves one of Jeff's concerns, what to do with pci_iomap().  That
> was designed to give mappings with caching enabled, and as a result we
> probably should make it behave that way.

Yes, it should.  Just be clear that *that* is a semantic change over 
what the code currently does; it would appear that that is what the code 
is *trying* to do.

I believe on x86 it will still get clamped by the MTRRs, at least 
initially (I don't think we have flipped the default MTRR type to WB 
yet) but that would immediately change the behaviour on non-x86 
architectures.

	-hpa
