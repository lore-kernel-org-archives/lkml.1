Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXDJCqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXDJCqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030319AbXDJCqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:46:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314AbXDJCqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:46:48 -0400
Date: Mon, 9 Apr 2007 19:46:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <20070409193056.6b52c354.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091944580.6730@woody.linux-foundation.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
 <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org>
 <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Apr 2007, Andrew Morton wrote:
> 
> >    10 ?        S<     0:00 [khelper]
> 
> That one's needed to parent the call_usermodehelper() apps.  I don't think
> it does anything else.  We used to use keventd for this but that had some
> problem whcih I forget.

I think it was one of a long series of deadlocks. 

Using a "keventd" for many different things sounds clever and nice, but 
then sucks horribly when one event triggers another event, and they depend 
on each other. Solution: use independent threads for the events.

		Linus
