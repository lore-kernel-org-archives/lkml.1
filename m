Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYKLUEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYKLUEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYKLUDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:03:55 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42264 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYKLUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:03:54 -0500
Subject: Re: [RFC] Add PR_PREFIX to pr_xyz macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
References: <1226511327.23498.3.camel@localhost>
	 <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 12 Nov 2008 20:59:02 +0100
Message-Id: <1226519942.2222.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:48 -0800, Linus Torvalds wrote:
> 
> On Wed, 12 Nov 2008, Martin Schwidefsky wrote:
> >
> > +#ifndef PR_PREFIX
> > +#define pr_fmt(format) format 
> > +#else
> > +#define pr_fmt(format) PR_PREFIX ": " format
> > +#endif
> > +
> > +#define pr_emerg(fmt, ...) \
> > +        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> 
> So, why can't people just define their pr_fmt() macro directly, something 
> like
> 
> 	#define pr_fmt(fmt) \
> 		"%s:%d " fmt, __FILE__, __LINE__
> 
> which seems to be much more useful and generic than forcing them to use 
> "PR_PREFIX"?

Even better - much better. With that define a lot more printk wrappers
could be replaced. I'll come up with a patch.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


