Return-Path: <linux-kernel-owner+w=401wt.eu-S938876AbXGSSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938876AbXGSSB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXGSSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:01:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765363AbXGSSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:00:58 -0400
Date: Thu, 19 Jul 2007 11:00:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
In-Reply-To: <m3vecgbjix.fsf@maximus.localdomain>
Message-ID: <alpine.LFD.0.999.0707191056010.27353@woody.linux-foundation.org>
References: <20070718235504.GA9601@havoc.gtf.org>
 <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
 <m3vecgbjix.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Krzysztof Halasa wrote:
> >
> >   We absolutely NEVER add things like "must_check" unless not checking 
> >   causes a real and obvious SECURITY ISSUE.
> 
> Oh, come on, almost every kernel bug is a potential security issue.

Sure. And adding unnecessary checking that doesn't make sense makes bugs 
*more* likely rather than less.

> IMHO, if the function can only fail due to a kernel bug, it should
> return void and, in case of bug, explode with BUG_ON() or something
> like that. Sure, must_check doesn't apply too well to void.

There are absolutely tons of functions that can return errors (or other 
values), and where many users MAY SIMPLY NOT CARE.

I think "must_check" is an abomination. It makes the callee dictate what 
the caller has to do, but dammit, if the callee really "knows" its errors 
are that serious, it should damn well handle them itself.

The whole "sysfs_create_file()" thing is an example of that. If it fails, 
it fails. The caller can't do anythign about it anyway, except perhaps 
print a message.  Why the hell does such a function have the "right" to 
dictate what the user should do?

That doesn't mean that *all* callers migth not care. Maybe some internal 
sysfs routines really should care. But not a random driver.

			Linus
