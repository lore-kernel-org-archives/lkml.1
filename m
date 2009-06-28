Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZF1SCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZF1SCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZF1SCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbZF1SCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:02:09 -0400
Date: Sun, 28 Jun 2009 11:01:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090628101654.GB8673@ucw.cz>
Message-ID: <alpine.LFD.2.01.0906281101030.3605@localhost.localdomain>
References: <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi> <20090624113037.7d72ed59.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
 <20090628101654.GB8673@ucw.cz>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 28 Jun 2009, Pavel Machek wrote:
> 
> Ok, so we should re-add that 4MB buffer to suspend, so that
> allocations work even during that, right?

Pavel, you really are a one-trick pony, aren't you?

Give it up. Return to your pet worry when there are any actual reports. As 
you have been told several times.

The _other_ part of memory management that you and Andrew seem to be 
ignoring is that it's very robust, and keeps extra memory around, and just 
generally does the right thing. We don't generally pre-allocate anything, 
because we don't need to.

Almost the _only_ way to run out of memory is to have tons and tons of 
dirty pages around. Yes, it can happen. But if it happens, you're almost 
guaranteed to be screwed anyway. The whole VM is designed around the 
notion that most of memory is just clean caches, and it's designed around 
that simply because if it's not true, the VM freedom is so small that 
there's not a lot a VM can reasonably do.

		Linus
