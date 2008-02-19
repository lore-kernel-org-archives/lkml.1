Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYBSOjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYBSOjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYBSOix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:38:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:58370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYBSOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fr3bYiaNF6MV3KxSLY3jAQBLJu3mb5Io0gp9KEPFNsZ8P9XHvygAO/3laYk+D0iE7P38hCar0L37I/8hgvzowSFiTqDAXm1ydj7WH3eTu2gulgPX0IxCeO9oeXHF5uKUVuNWiXYyUPK7Tmcgp8LGs/FMOSq3BJrSKTTo1B99N+A=
Message-ID: <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
Date: Tue, 19 Feb 2008 16:38:50 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: Linux 2.6.25-rc2
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
	 <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	 <20080219140230.GA32236@Krystal>
	 <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
X-Google-Sender-Auth: aa0176030513cce2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Feb 19, 2008 4:02 PM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > Since this shows mostly with network card drivers, I think the most
> > plausible cause would be an IRQ nesting over kmem_cache_alloc_node and
> > calling it.

On Feb 19, 2008 4:21 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Yes, this can happen. Are you saying it is not safe to be in the
> lockless path when an IRQ triggers?

Hmm. The barrier() in slab_free() looks fishy. The comment says it's
there to make sure we've retrieved c->freelist before c->page but then
it uses a _compiler barrier_ which doesn't affect the CPU and the
reads may still be re-ordered... Not sure if that matters here though.
