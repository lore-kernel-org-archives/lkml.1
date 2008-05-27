Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYE0Peh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYE0Peh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYE0Pe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:34:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47199 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbYE0PeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:34:25 -0400
Date: Tue, 27 May 2008 09:34:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com,
       rusty@rustcorp.com.au, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Message-ID: <20080527153406.GL30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com> <20080527131325.GJ30894@parisc-linux.org> <1211896108.1746.3.camel@localhost.localdomain> <1211900915.18130.251.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211900915.18130.251.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 08:08:35AM -0700, Daniel Walker wrote:
> 
> On Tue, 2008-05-27 at 09:48 -0400, Dan Williams wrote:
> > 
> > Yeah, that might be the right way to go.  If you want to jump into the
> > driver, feel quite free, but I don't think you need to go into too much
> > detail with it.  Your overall behavior analysis is right on the mark
> > already.
> 
> I think we could just remove the trylock from the interrupt case, and
> always force the wake_up_interruptible(&priv->thr_wait) case. It looks
> like the trylocking is just an optimization to save a wakeup ..

'just'?  I think you'd see severe performance reductions if you had to
do a wakeup for every interrupt.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
