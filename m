Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXHLKMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXHLKMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXHLKLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:11:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:49475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229AbXHLKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:11:36 -0400
From: Andi Kleen <ak@suse.de>
To: discuss@x86-64.org
Subject: Please remove ab144f5ec64c42218a555ec1dbde6b60cf2982d6 was Re: [discuss] [PATCH] Fix triplefault on x86-64 bootup
Date: Sun, 12 Aug 2007 12:09:40 +0200
User-Agent: KMail/1.9.1
Cc: Petr Vandrovec <petr@vandrovec.name>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070812081252.GA23309@vana.vc.cvut.cz>
In-Reply-To: <20070812081252.GA23309@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121209.40995.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 10:12, Petr Vandrovec wrote:
> Hello,
>   after I upgraded kernel on my box to current git, only thing it did
> was rebooting in a loop.  After some digging I found that it is silly
> to apply alternative to memcpy by using that every same memcpy...
> Sorry if it is known bug, I do not see it reported in my LKML mailbox...

Ok Linus already applied your patch. Even though it's a really 
bad fragile hack, not better than the old bug.

Petr are you double sure you really tested with
ab144f5ec64c42218a555ec1dbde6b60cf2982d6
already applied? I bet not -- it is the symptom exactly fixed by this patch
(although 

Linus, I would prefer if you reverted 
b8d3f2448b8f4ba24f301e23585547ba1acc1f04
again -- it should really not be needed with 
ab144f5ec64c42218a555ec1dbde6b60cf2982d6

And I really dislike Petr's patch because while it might work
today (I'm not 100% sure it actually works to only replace
2 bytes) if we change memcpy ever it'll likely cause strange 
problems again.

-Andi
