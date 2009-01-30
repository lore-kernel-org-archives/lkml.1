Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZA3CJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZA3CJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZA3CJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:09:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZA3CJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:09:02 -0500
Date: Thu, 29 Jan 2009 18:08:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
  file segments
In-Reply-To: <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Maksim Yevmenkin wrote:
> 
> Just to confirm. This patch also appear to fix the immediate issue for us.

Ok, I ended up committing it.

I didn't do the whole "Cc: stable@kernel.org" thing, because maybe the 
non-cleanup version is less controversial for stable, but I decided that 
there's no way I don't want the cleanup done in mainline kernel, and if we 
end up needing a few VM_IO's added, I think it's worth it. Even after -rc3 
(since I suspend we won't actually need them).

		Linus
