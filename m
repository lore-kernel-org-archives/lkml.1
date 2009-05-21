Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZEUTBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZEUTBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZEUTBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:01:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30170 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZEUTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:01:38 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52123629"
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>
	 <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
	 <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
	 <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
	 <4A1592CF.8000208@goop.org>
	 <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Thu, 21 May 2009 20:01:37 +0100
Message-ID: <1242932497.25553.230.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 14:27 -0400, Becky Bruce wrote:
> We have both in every case but one,  
> which is in swiotlb_map_page where we call address_needs_mapping()  
> without calling range_needs_mapping.

The reason it calls address_needs_mapping without range_needs_mapping is
that in the swiotlb_force=1 case it would trigger every time. If
address_needs_mapping and range_needs_mapping are merged as proposed and
they do not subsume the swiotlb_force check (and I don't think they
would) then I think this will work fine.

> It's not actually clear to me that we need that check, though.  Can 
> someone explain what case that was designed to catch?

If map_single fails and returns NULL then we try to use
io_tlb_overflow_buffer, if that is somehow not DMA-able (for the
particular device) then the check will trigger. I would have thought we
could arrange that the overflow buffer is always OK and really if
map_page is failing we must be close the edge already.

Ian.

