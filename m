Return-Path: <linux-kernel-owner+w=401wt.eu-S1767222AbXDEU6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767222AbXDEU6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767282AbXDEU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:58:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51634 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767222AbXDEU6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:58:14 -0400
Date: Thu, 5 Apr 2007 13:57:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
Message-ID: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Apr 2007, Robin Holt wrote:
> 
> For testing, Jack Steiner create the following patch.  All it does
> is moves tasks which are transitioning to the zombie state from where
> they are in the children list to the head of the list.  In this way,
> they will be the first found and reaping does speed up.  We will still
> do a full scan of the list once the rearranged tasks are all removed.
> This does not seem to be a significant problem.

I'd almost prefer to just put the zombie children on a separate list. I 
wonder how painful that would be..

That would still make it expensive for people who use WUNTRACED to get 
stopped children (since they'd have to look at all lists), but maybe 
that's not a big deal.

Another thing we could do is to just make sure that kernel threads simply 
don't end up as children of init. That whole thing is silly, they're 
really not children of the user-space init anyway. Comments?

		Linus
