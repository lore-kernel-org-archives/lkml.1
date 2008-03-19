Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYCST0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYCST0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYCSTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:24:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYCSTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:45 -0400
Date: Tue, 18 Mar 2008 21:48:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <200803190503.27719.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0803182135570.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803190424.30971.bzolnier@gmail.com> <alpine.LFD.1.00.0803182013090.3020@woody.linux-foundation.org> <200803190503.27719.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Your patch is more robust and we should go with it
> (and thanks for fixing this bug!).

Ok, I committed the patch as-is, since it's what Anders tested, but I'm 
not at all convinced that it is necessarily the best or final form. The 
things I am aware of but didn't think about all *that* deeply:

 - do we get return values etc right (ie if we complete the command that 
   didn't give any data, how do we account the size of it?)

 - what about that remaining old unexpected case? I kept the "wait for it 
   with timeout" behaviour for the case that wasn't an issue here, but if 
   it really is a shared interrupt, that seems like it's going to always 
   reset the timeout to WAIT_WORSTCASE, which doesn't sound really right.

so I think this particular bug is fixed and we should be better off, but 
I'm definitely not claiming that the code shouldn't have people thinking 
about improving it..

			Linus
