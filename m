Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYG3WAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYG3WAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYG3WAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYG3WAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:00:19 -0400
Date: Wed, 30 Jul 2008 14:56:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KOJUk-0002vA-8w@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0807301453510.3277@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org> <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
 <E1KOJ1s-0002a5-Im@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301418270.3277@nehalem.linux-foundation.org> <E1KOJUk-0002vA-8w@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> 
> You are being unfair: after having talked it over with Nick I
> resubmitted this patch (not the same), which was added to -mm and
> nobody complained then. Then it got thrown out of -mm during the merge
> window because of a conflict, and then now I got around to
> resubmitting it again.

Ok, fair enough. I don't follow -mm myself (since as far as I'm concerned, 
a lot of the point of -mm is that Andrew takes a lot of load off me). So 
yes, it was unfair and yes, I'd never have reacted to it in -mm.

But I'd really like to get that PG_uptodate bit just fixed - both wrt 
writeout errors and wrt truncate/holepunch. We had some similar issues wrt 
ext3 (?) inode buffers, where removing the uptodate bit actually ended up 
being a mistake.

			Linus
