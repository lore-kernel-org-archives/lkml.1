Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXK1XeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXK1XeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXK1XeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:34:09 -0500
Received: from main.gmane.org ([80.91.229.2]:42776 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbXK1XeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:34:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Question regarding mutex locking
Date: Wed, 28 Nov 2007 15:33:12 -0800
Organization: Linux Foundation
Message-ID: <20071128153312.14144472@freepuppy.rosehill>
References: <474CF06C.8020208@lwfinger.net>
	<jemysy2y3y.fsf@sykes.suse.de>
	<474D8C22.7010902@lwfinger.net>
	<474DEF79.1080900@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <474DEF79.1080900@o2.pl>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 23:45:13 +0100
Jarek Poplawski <jarkao2@o2.pl> wrote:

> Larry Finger wrote, On 11/28/2007 04:41 PM:
> 
> > Andreas Schwab wrote:
> >> Larry Finger <Larry.Finger@lwfinger.net> writes:
> >>
> >>> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> >>> would the following code be SMP safe?
> >>>
> >>> hold_lock = mutex_trylock()
> >>>
> >>> ...
> >>>
> >>> if (hold_lock)
> >>> 	mutex_unlock()
> >> When two CPUs may enter the critical region at the same time, what is
> >> the point of the mutex?  Also, the first CPU may unlock the mutex while
> >> the second one is still inside the critical region.
> > 
> > Thank you for that answer. I think that I'm finally beginning to understand.
> 
> Probably it would be faster without these "...", which look like
> no man's land...
> 
> hold_lock = mutex_trylock()
> if (hold_lock) {
> 	/* SMP safe */
> 	...
>  	mutex_unlock()
> } else {
> 	/* SMP unsafe */
> 	...
> 	/* maybe try again after some break or check */
> }
> 
> Regards,
> Jarek P.

WTF are you teaching a lesson on how NOT to do locking?

Any code which has this kind of convoluted dependency on conditional
locking is fundamentally broken.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

