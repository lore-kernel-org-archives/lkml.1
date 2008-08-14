Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYHNU0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYHNU0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYHNUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:25:53 -0400
Received: from gw.goop.org ([64.81.55.164]:60750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYHNUZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:25:52 -0400
Message-ID: <48A494B0.3050509@goop.org>
Date: Thu, 14 Aug 2008 13:25:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: dirty page accounting race fix
References: <20080814094537.GA741@wotan.suse.de>  <Pine.LNX.4.64.0808141210200.4398@blonde.site> <1218716318.10800.209.camel@twins> <Pine.LNX.4.64.0808141328090.11013@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808141328090.11013@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> I realized that was the intended optimization, what I'd missed is that
> dirty_accountable can only be true there if (vma->vm_flags & VM_WRITE):
> that's checked in vma_wants_writenotify(), which is how dirty_accountable
> gets to be set.
>
> So those lines are okay, panic over, phew.
>   

I got bitten by precisely the same train of thought.  I think that code 
officially Non Obvious (or at least Not Immediately Obvious, which is 
bad in security-sensitive code).

    J
