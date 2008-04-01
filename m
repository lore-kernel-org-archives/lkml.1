Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYDAN1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYDAN1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYDAN1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:27:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYDAN1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:27:08 -0400
Date: Tue, 1 Apr 2008 15:30:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
Message-ID: <20080401133053.GJ29105@one.firstfloor.org>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz> <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz> <20080401083359.GB32272@elte.hu> <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz> <874pal25iu.fsf@basil.nowhere.org> <Pine.LNX.4.64.0804011436150.5541@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804011436150.5541@jikos.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 02:40:49PM +0200, Jiri Kosina wrote:
> On Tue, 1 Apr 2008, Andi Kleen wrote:
> 
> > At some point -- but that was before queued locks -- I noticed that for 
> > i386 spin unlocks the call sequence for the sub function is actually 
> > larger in code than the actual spin unlock operation and for x86-64 it 
> > was about the same. 
> 
> spin unlocks seem to be properly inlined anyway, so that should be fine. 
> My concern here is the non-inlining of spin locks, for which I don't think 
> your argument above is also valid, right?

When I did the original numbers (again before queued locks) the
call was slightly shorter than the actual spin lock operation.

This was not counting register allocator effects though which
are difficult to measure generally.

-Andi
