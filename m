Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbYG3REG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbYG3REG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYG3RDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:03:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbYG3RDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:03:53 -0400
Date: Wed, 30 Jul 2008 10:00:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> 
> There are no real disadvantages: splice() from a file was originally meant to
> be asynchronous, but in reality it only did that for non-readahead pages,
> which happen rarely.

I still don't like this. I still don't see the point, and I still think 
there is something fundamentally wrong elsewhere.

I also object to just dismissing the async nature as unimportant. Fix it 
instead. Make it use generic_file_readahead() or something. This is fixing 
things in all the wrong places, imnsho.

			Linus
