Return-Path: <linux-kernel-owner+w=401wt.eu-S940555AbYCSWT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940555AbYCSWT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964981AbYCSUwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:52:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64314 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985AbYCSUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:52:19 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Wed, 19 Mar 2008 12:14:02 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803190503.27719.bzolnier@gmail.com> <alpine.LFD.1.00.0803182135570.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803182135570.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803191214.03035.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2008, Linus Torvalds wrote:
> 
> On Wed, 19 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Your patch is more robust and we should go with it
> > (and thanks for fixing this bug!).
> 
> Ok, I committed the patch as-is, since it's what Anders tested, but I'm 
> not at all convinced that it is necessarily the best or final form. The 

Thanks.

> things I am aware of but didn't think about all *that* deeply:
> 
>  - do we get return values etc right (ie if we complete the command that 
>    didn't give any data, how do we account the size of it?)

Yeah, closer look would be needed there.

>  - what about that remaining old unexpected case? I kept the "wait for it 
>    with timeout" behaviour for the case that wasn't an issue here, but if 
>    it really is a shared interrupt, that seems like it's going to always 
>    reset the timeout to WAIT_WORSTCASE, which doesn't sound really right.

This shared IRQs quirk should no longer be necessary so probably the best
way to handle BSY there would be to give drive some last chance and if it
is still BSY treat is as error.

> so I think this particular bug is fixed and we should be better off, but 
> I'm definitely not claiming that the code shouldn't have people thinking 
> about improving it..

Definitevely, I'll try to address "old unexpected case" for 2.6.26
(+ I'll keep looking for other issues as time permits) and of course
I'll be happy to review/merge any patches improving this area.

Bart
