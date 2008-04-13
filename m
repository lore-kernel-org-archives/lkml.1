Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYDMMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYDMMwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYDMMwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:52:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33458 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDMMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:52:22 -0400
Date: Sun, 13 Apr 2008 06:52:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080413125205.GP11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080413070513.GB19773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413070513.GB19773@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 09:05:13AM +0200, Ingo Molnar wrote:
> there's also another aspect: completions are faster a bit 
> in theory, because they know that they will schedule most of the time - 
> while semaphores assume that they will _not_ schedule. (And that's 
> exactly because the intent of the developer when using a completion is 
> crystal clear.)

In practice though, the current implementation is slower.  Of course,
that's fixable, and I strongly suspect that the current users of
completions simply don't care about speed -- the normal use of
completions is in startup and shutdown paths where a millisecond extra
isn't going to be noticable.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
