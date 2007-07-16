Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXGPXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXGPXwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXGPXwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:52:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:53327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXGPXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S2Bh5y02MZu011ord2i7zAEESoDqVoD7sA3Nz5cg9ZNbqK2U9OSaS8GXmqjDsvpTmYCL9lBfXFekv6W3RI4sbycETr3otTt7SSxm/noHu29waGcuJp7KWZTTdpSFfHX0PDn+Dq02aVBN+FhkDqoWkup3ri5+XC0l/oboWngc9Iw=
Message-ID: <9a8748490707161651s99fb57l4df9f87d79d87cc3@mail.gmail.com>
Date: Tue, 17 Jul 2007 01:51:58 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Rene Herman" <rene.herman@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0707170134390.29868@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it>
	 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>
	 <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	 <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
	 <Pine.LNX.4.58.0707170134390.29868@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, Bodo Eggert <7eggert@gmx.de> wrote:
> On Tue, 17 Jul 2007, Jesper Juhl wrote:
>
> > Please note that I was not trying to remove the 8K stack option right
> > now - heck, I didn't even add anything to feature-removal-schedule.txt
> > - all I wanted to accomplish with the patch that started this threas
> > was;  a) indicate that the 4K option is no longer a debug thing  and
>
> Very ACK.
>
Ok, so perhaps a patch to do just that bit could go towards mainline
(possibly after a short stay in -mm).

> > b) make 4K stacks the default option in vanilla kernel.org kernels as
> > a gentle nudge towards getting people to start fixing the code paths
> > that are not 4K stack safe.
>
> That's the big NACK. It's OK for MM, where things are supposed to be in a
> not well-tested state, but for running possibly mission-critical systems,
> you should take no risk.
>
Hmm, I guess it would make sense to stick it in -mm for an extended
period of time, but hold off on mainline until we start hearing
positive noises that people can no longer break 4K stacks...

> If you'd run a 4K stack on the NFS+XFS+LVM+dmcrypt+MD+somethingmore
> setup driving your loved one's life support, you may go ahead.

;-)


How about if I split it into two tiny patches
 - one that just makes it no longer a debug option and moves the
option out of the "kernel hacking" submenu and into "general setup"
instead, but leave it to default to N.
 - and then one that makes it default Y.
and then submit those two patches to Andrew for inclusion in -mm with
a clear note that only the first one should go upstream anytime soon
and the second one should be kept "strictly -mm" until we arrive at
the point in time where people can no longer break 4K.
How does that sound?
>From my point of view that would accomplish my objective of getting 4K
stacks some more testing and the indication that long-term that's the
way we probably want to move.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
