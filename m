Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZEUWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZEUWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZEUWIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:08:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3555 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZEUWIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:08:16 -0400
X-IronPort-AV: E=Sophos;i="4.41,230,1241409600"; 
   d="scan'208";a="52147149"
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A15B72E.2070202@goop.org>
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>
	 <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
	 <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
	 <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
	 <4A1592CF.8000208@goop.org>
	 <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
	 <4A15B72E.2070202@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Thu, 21 May 2009 23:08:16 +0100
Message-ID: <1242943696.25553.658.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 16:18 -0400, Jeremy Fitzhardinge wrote:
> I guess the test is checking for a bad implementation of map_single().

More importantly the io_tlb_overflow_buffer is basically a second chance
if you exhaust the swiotlb pool. The check seems to be there to ensure
that the second chance memory is suitable for the device (it's hard to
imagine, but possible I suppose, that it wouldn't be), a bad
implementation of map_single() is a secondary concern I suspect.

If all the callers of map_page did proper error handling this would all
be unnecessary. I guess someone was worried, at least at one point, that
they didn't. The failure case could possibly be scribbling into a random
memory location or more worryingly sprinkling random memory locations
onto your disk or whatever. That said I'd imagine that map_page
returning NULL would cause an oops long before anything tried to DMA
anything and the second chance probably doesn't buy us much in practice.

Ian.


