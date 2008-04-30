Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYD3KGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYD3KGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYD3KGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:06:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46085 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282AbYD3KGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:06:14 -0400
Date: Wed, 30 Apr 2008 04:06:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080430100612.GI14976@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org> <20080428051040.GH103491721@sgi.com> <20080428122004.GT14990@parisc-linux.org> <20080429000929.GF108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429000929.GF108924158@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:09:30AM +1000, David Chinner wrote:
> > 2. l_flushsema
> > 
> > This seems to be a completion.  ie you're using it to wait for the log
> > to be flushed.
> 
> Yes, that could probably be a completion. I'm assuming that a completion
> can handle several thousand waiting processes, right?

By the way ... is it common that you get several thousand waiting
processes?  I ask because you wake them all up, then the herd thunders
into the l_icloglock spinlock.  Or is this a worst-case scenario that
happens once in a blue moon?

If l_flushsema does typically get more than one waiter, we can instead
wake the waiters one at a time.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
