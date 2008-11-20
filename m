Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYKTDgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYKTDgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 22:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYKTDgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 22:36:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbYKTDgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 22:36:02 -0500
Date: Wed, 19 Nov 2008 19:35:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Ratan Nalumasu <rnalumasu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_wait wakeup optimization
In-Reply-To: <20081120012017.3CC3C15423A@magilla.localdomain>
Message-ID: <alpine.LFD.2.00.0811191929450.21698@nehalem.linux-foundation.org>
References: <93ad5f3f0808181334i684e68b7yb61e3586d35880f6@mail.gmail.com> <93ad5f3f0808181804m3b74fe68v1fdcf4edf6c7b465@mail.gmail.com> <20080819214546.9BD5715426B@magilla.localdomain> <93ad5f3f0808191746g44acbccdm715222698ed20ee1@mail.gmail.com>
 <20080820010415.EB87B15449D@magilla.localdomain> <93ad5f3f0808191851i1fdd0332g8befbc538551f24@mail.gmail.com> <93ad5f3f0808221333pe9b95fp886f6313b4be384e@mail.gmail.com> <20080823013655.F3B3615426C@magilla.localdomain> <93ad5f3f0808261601g4fa6429dgbcb21e4218e92f2a@mail.gmail.com>
 <20080826230620.5865E154233@magilla.localdomain> <93ad5f3f0811191404g28361b1ei329c3e326b21087d@mail.gmail.com> <20081120012017.3CC3C15423A@magilla.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Nov 2008, Roland McGrath wrote:
>
> Ratan Nalumasu reported that in a process with many threads doing
> different, mutually-exclusive waitpid() calls, there were a lot of
> unnecessary wakeups.  Every waiting thread in the process wakes up to
> loop through the children and see that the only ones it cares about
> are still not ready.

Patch looks sane, and look worth queueing up for the next merge window. 
But if somebody actually has numbers and/or can talk about the real-life 
load that made people even notice this, that would be good to add to the 
description.

Also, do we really need to call eligible_child() twice? The real wait only 
does it once in that "wait_consider_task()". Explanations would be good..

			Linus
