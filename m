Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYEUEhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYEUEhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYEUEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:37:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYEUEhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:37:46 -0400
Date: Tue, 20 May 2008 21:36:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       wim@iguana.be, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Message-Id: <20080520213654.a25d286e.akpm@linux-foundation.org>
In-Reply-To: <200805211426.16234.rusty@rustcorp.com.au>
References: <20080519124659.31722.51847.stgit@core>
	<20080519130625.31722.68489.stgit@core>
	<20080520012658.274b0c1e.akpm@linux-foundation.org>
	<200805211426.16234.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 14:26:15 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> > decent-sized smashup during the merge window.  There are lessons
> > here...
> 
> I've been pulling out s/down_trylock/down_nowait/ patches which effect others' 
> changes.  Those patches get moved to the end of my queue, and I'll revisit 
> them before an actual merge with Linus.
> 
> As down_trylock still works (but marked deprecated) with my patches, they're 
> fine to drop.  Just tell me which ones...

Well, a simple patch which does

/*
 * comment goes here
 */
static inline int __must_check down_nowait(struct semaphore *sem)
{
	return !down_trylock(sem);
}

and which does not deprecate down_trylock() could go into mainline
right now, (assuming that the overall concept doesn't get shot down in
review - did it get reviewed?)

Then you can start trickling stuff out to people straight away.
