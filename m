Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYJATl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYJATl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYJATlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:41:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54411 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYJATlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:41:20 -0400
Date: Wed, 1 Oct 2008 21:46:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Vegard Nossum <vegardno@ifi.uio.no>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Message-ID: <20081001194655.GZ25711@one.firstfloor.org>
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com> <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com> <48E35E83.9040101@gmail.com> <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com> <20081001165246.GY25711@one.firstfloor.org> <48E3D03C.5010808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3D03C.5010808@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but __pa() used for converting to a physical address used as a parameter
> for __pfn_valid() will panic on invalid addresses passed to it when DEBUG_VIRTUAL=y.

Ok that's a bug indeed.

> Anyway virt_addr_valid() is IMHO wrong. E.g. first modules VM address
> 0xffffffffa0000000 is after __pa() 200M which is valid pfn after the shift even
> on the flatmem model with enough memory.
> 
> Am I missing something? What's the exact purpose of the virt_addr_valid()?

I think it's supposed to be only used on direct mapping anyways (judging
from a quick look a the users)

So not handling text mapping is ok, but don't panic on it.

-Andi

-- 
ak@linux.intel.com
