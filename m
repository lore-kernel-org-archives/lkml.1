Return-Path: <linux-kernel-owner+w=401wt.eu-S964816AbXBLKZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816AbXBLKZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964840AbXBLKZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:25:46 -0500
Received: from mx1.suse.de ([195.135.220.2]:48017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964827AbXBLKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:25:40 -0500
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH 2.6.21 review I] [21/25] x86_64: a memcpy that tries to reduce cache pressure
Date: Mon, 12 Feb 2007 11:25:28 +0100
User-Agent: KMail/1.9.5
Cc: "Bryan O'Sullivan" <bos@pathscale.com>,
       "Roland Dreier" <rolandd@cisco.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <200702101250.142420000@suse.de> <20070210115034.694B013DBF@wotan.suse.de> <45D04806.76E4.0078.0@novell.com>
In-Reply-To: <45D04806.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121125.28867.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This looks a little strange to me:
> - the first 128 bytes are still going through the cache
> - up to 192 bytes past the copied area are being marked non-temporal, while
>   there's nothing known about that area

Yes that seems quite bogus.

> - sfence seems questionable here, I would have thought this should be lfence,
>   or perhaps even none at all

Agreed -- it's not needed.

I think i also objected earlier to the jump table which is likely slower.

Will drop for now.

-Andi
