Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYCKLdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYCKLdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYCKLd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:33:29 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:53434 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYCKLd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:33:29 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [RFC] Stacking bio support
Date: Tue, 11 Mar 2008 12:33:21 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200803110352.41479.phillips@phunq.net>
In-Reply-To: <200803110352.41479.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803111233.21386.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Daniel!

On Dienstag, 11. März 2008, Daniel Phillips wrote:
> 3: bio.stack-2.6.23.12
>
> This adds an internal stack to each struct bio and introduces two new
> bio operations:
>
>         data = bio_push(bio, worksize, endio);
>         data = bio_pop(bio);
>
> The first is used before submitting a bio and the second is used in the
> endio handler, which gives the driver a nice way to share context
> between the two events.  If the requested amount stack space is not
> available in the bio, the bio stack is automatically extended.
...
> (I learned from Andreas Dilger last month at FAST that Lustre already
> implements a mechanism along these lines.)
Win32 has IRP stacks, which do mostly the same AFAIU.
	http://msdn2.microsoft.com/en-us/library/ms796144.aspx

How do you handle the reallocation?
- If you don't do it (but rely on the fact that the initial allocation is
  enough), you might end up with NO_MORE_IRP_STACK_LOCATIONS
    http://msdn2.microsoft.com/en-us/library/ms793675.aspx
- If you do reallocate, the allocations have to register themselves in
  the emergency pool (see the current thread about swapping over NFS)

I don't say that it's impossible ... just that some "interesting" things will 
await you. 

> Currently the stack size in the bio is set to zero and is always
> extended on the first bio_push.  An upcoming revision will add a
> mechanism for a block driver to specify the initial amount of stack
> space it knows will always be needed.  Some time further in the future,
> a mechanism for discovering the stack requirements of several block
> devices in a stack may be added, so that a typical bio submission is
> able to traverse the entire stack with only a single bio allocation.
That's different from the Win32 way AFAIK - there it's defined that every 
layer *has* to use its own stack location. (But it's been some time since I 
needed that, so I might be wrong.)


But I sure hope you succeed!


Regards,

Phil
