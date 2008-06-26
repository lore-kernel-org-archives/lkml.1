Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYFZLnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYFZLnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYFZLm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:42:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38124 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYFZLm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:42:58 -0400
Date: Thu, 26 Jun 2008 05:42:42 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush requirements
Message-ID: <20080626114242.GX4392@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626112612.GW4392@parisc-linux.org> <20080626113209.GK11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626113209.GK11558@disturbed>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 09:32:09PM +1000, Dave Chinner wrote:
> On Thu, Jun 26, 2008 at 05:26:12AM -0600, Matthew Wilcox wrote:
> > On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > > XFS object flushing doesn't quite match existing completion semantics.  It
> > > mixed exclusive access with completion. That is, we need to mark an object as
> > > being flushed before flushing it to disk, and then block any other attempt to
> > > flush it until the completion occurs.
> > 
> > This sounds like mutex semantics.  Why are the existing mutexes not
> > appropriate for your needs?
> 
> Different threads doing wait and complete.

Then let's leave it as a semaphore.  You can get rid of the sema_t if
you like, but I don't think that turning completions into semaphores is
a good idea (because it's confusing).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
