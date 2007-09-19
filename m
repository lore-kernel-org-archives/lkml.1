Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXISLnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXISLnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXISLnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:43:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:47303 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbXISLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EotRHZpImcOXsRRROJWh2G3I7xYII2pNrJFx6mpL7sHPnZ9NiGvAcoaTHI7v5CQwz9FMRsVg4D0UHHusFsjTv8P0xzosF46138SBbten2Uilo/l6BptOhMP4i9zjetbyAz7jVZr0bim9bXRQXjpw3kGOicWLADZWDbngxMro9iU=
Message-ID: <46F10B69.5070008@gmail.com>
Date: Wed, 19 Sep 2007 13:43:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2007 10:18 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> 
> 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> 
> It took me over two solid days to get this lot compiling and booting on a few
> boxes.  This required around ninety fixup patches and patch droppings.  There
> are several bugs in here which I know of (details below) and presumably many
> more which I don't know of.  I have to say that this just isn't working any
> more.
> 
> - The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
>   I didn't drop that patch because the iommu patch series depends on it.

No matter whether slub/slab is selected someone gets a page and moves/adds its
.lru head to some list after being in the deffered_pages list yet -- this breaks
the deffered_pages list and loops forever in list_for_each (unless LIST_DEBUG is
selected, which produces a BUG).

Any ideas who could be the one pushing the page to some other list?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
