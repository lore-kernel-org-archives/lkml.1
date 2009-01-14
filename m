Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZANSSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZANSSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZANSRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:17:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZANSRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:17:53 -0500
Date: Wed, 14 Jan 2009 13:17:48 -0500
From: Kyle McMartin <kyle@infradead.org>
To: richard kennedy <richard@rsk.demon.co.uk>
Cc: Kyle McMartin <kyle@infradead.org>, Takashi Iwai <tiwai@suse.de>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
Message-ID: <20090114181748.GQ25103@bombadil.infradead.org>
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de> <20090114155859.GO25103@bombadil.infradead.org> <496E261F.9000803@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E261F.9000803@rsk.demon.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 05:51:27PM +0000, richard kennedy wrote:
> Aside from the code in socket does this reference count really get used
> that often? Atomic_t gets used for ref counts is lots of other places in
> the kernel, so why not turn module_ref into an atomic counter & drop the
> array entirely saving all of the memory & disk space?
> 
> I do wonder if socket could manage its module lifetimes in some other
> way, then we really could just use an atomic module ref without too much
> impact. I didn't get very far in trying to work out what exactly was
> going on in socket.c but maybe it's worth another look.
> 

I suppose it depends on how much contention there will end up being on
the atomic_t, given that right now, the module_ref structure favours
writers (since readers need to loop.) 

I'd like to hear what rusty has to say, but I'm working on a patch
to do module_ref with RCU (and to allocate it in modpost with per_cpu
variables, but that needs more testing.) I'll check what kind of
difference those end up making.

> I don't have any network test harness so it's difficult to tell what
> impact any code change is going to have. Do you have any suggestions for
> a good test of this?
> 

No, but I imagine Rick Jones' netperf would show the effect, if any.

cheers, Kyle
