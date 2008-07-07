Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYGGMJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYGGMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYGGMJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:09:18 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:58162 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYGGMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=fHt1t1iaH8sXrvV3vgNhto7LIxtMs7M55b6LxfBCX9CSc6/deoj84hz8uUn/CKA+LH
         Uh9ZUvCCH+cS9c8Uox5wTXibrurJtCyraszuDvUX+DVg696Fh5DpTrfkebJCOVG/8XIE
         p5F6MkkAosEu+Z5S73amAlbxBDwkOp199CEEE=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org>
Date: Mon, 07 Jul 2008 14:09:10 +0200
In-Reply-To: <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 2 Jul 2008 19:35:11 -0700 (PDT)")
Message-ID: <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Now, the stuff that comes *before* that point is the "try to fix up one 
> byte at a time" thing, which I'd like to be simple and dumb. At least to 
> start with.

Just to be clear: do these patches are good enough now (to start with)?
Or, may be, it needs to be further improved?

> Of course, I also suspect that *eventually* we might want to make it 
> smarter and more complex. For example, while performance isn't a primary 
> issue, we might want to eventually avoid having to do _two_ faults (once 
> in the fast unrolled or word-at-a-time loop, and once in the byte-for-byte 
> one), by limiting the byte-for-byte one to be within a page, but that 
> would be a "future enhancement" thing.

Btw, how much does it cost to CPU to do a fault? Can it be compared with
average time of find_vma()?

-- 
wbr, Vitaly
