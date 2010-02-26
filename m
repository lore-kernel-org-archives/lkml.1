Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615Ab0BZLzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:55:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935516Ab0BZLzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:55:16 -0500
To: roel kluin <roel.kluin@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       mikpe@it.uu.se, linux-crypto@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in  sha1_update()
From: Andi Kleen <andi@firstfloor.org>
References: <4B8692E3.9030509@gmail.com>
	<20100225.071759.98314060.davem@davemloft.net>
	<25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com>
Date: Fri, 26 Feb 2010 12:55:14 +0100
In-Reply-To: <25e057c01002250731q68bb9e28ld009163f2a009f48@mail.gmail.com> (roel kluin's message of "Thu, 25 Feb 2010 16:31:36 +0100")
Message-ID: <87sk8oqkil.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin <roel.kluin@gmail.com> writes:

>> And it's wrong because the reason the memset() is there seems to be
>> to clear out key information that might exist kernel stack so that
>> it's more difficult for rogue code to get at things.
>
> If the memset is optimized away then the clear out does not occur. Do you
> know a different way to fix this? I observed this with:

You could always cast to volatile before memsetting?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
