Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZFXSve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZFXSve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZFXSvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:51:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbZFXSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:51:25 -0400
Date: Wed, 24 Jun 2009 11:50:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <84144f020906241144of2c85c7xc5f258a7837896c9@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906241147460.3240@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>  <20090624094622.d0b0fd82.akpm@linux-foundation.org>  <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>  <20090624105517.904f93da.akpm@linux-foundation.org>  <4A426825.80905@cs.helsinki.fi> 
 <20090624113037.7d72ed59.akpm@linux-foundation.org>  <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <84144f020906241144of2c85c7xc5f258a7837896c9@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Pekka Enberg wrote:
> 
> That said, I do think we ought to fix SLUB not to use __GFP_FAIL for
> the higher order allocation regardless of this patch.

I agree. Within the context of SLUB, it makes absolute sense.

That's especially true since SLUB already uses __GFP_NORETRY or whatever. 

The combination of __GFP_NOFAIL | __GFP_NORETRY is just insane. So your 
patch to remove __GFP_NOFAIL when adding __GFP_NORETRY is absolutely the 
ObviouslyCorrectThingToDo(tm).

Please integrate that, and take my patch too if you would (add my sign-off 
or just do your own version)? Or should I just apply them?

		Linus
