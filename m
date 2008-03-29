Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbYC2Xw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbYC2Xw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 19:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYC2XwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 19:52:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12358 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYC2XwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 19:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VdLS/TBVlRybrJotTSQ0ITVRw4s2/8LM+s0gXegzdckUU/wdXzOSm3EKvO4vkgV0q8vcB/KLobDq/xps5mGyoY4zEGnQJC76FcpnoMa7UYZsaBOjbTzvWa8eWNvFJY7meNKKEgeDqDVEeJ3sMCGtW4Ldqj3eRPG6kQWgtIGupWM=
Message-ID: <84144f020803291652l13d3de82o424e126655b86119@mail.gmail.com>
Date: Sun, 30 Mar 2008 01:52:18 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Cc: "Christoph Lameter" <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pawel Staszewski" <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803272353.51901.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803291422160.14670@woody.linux-foundation.org>
X-Google-Sender-Auth: de69d19777f00492
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 29 Mar 2008, Christoph Lameter wrote:
>  > Yes it uses its own logic if the object is managed by SLUB but not if the
>  > object is too big and/or the allocation forwarded to the page allocator
>  > or for other internal allocations of buffers etc.

On Sat, Mar 29, 2008 at 11:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  Wrong.
>
>  It uses it's own logic for __GFP_ZERO *regardless* of size.

Christoph, I think you're overlooking the same thing I was until Linus
straightened me out. We're calling kmalloc_large() from __slab_alloc()
for the fall-back case which causes a bug fixed by Linus' revert.

On Sat, Mar 29, 2008 at 11:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  You don't have a f*cking clue about this cocde that you're supposed to be
>  maintaining, do you?

Yeah, me too. Fortunately we have you as our upstream maintainer :-).

                        Pekka
