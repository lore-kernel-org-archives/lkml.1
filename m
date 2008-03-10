Return-Path: <linux-kernel-owner+w=401wt.eu-S1751950AbYCJMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbYCJMXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYCJMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:23:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:17691 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYCJMXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s4PzS6SFEnmZP9R+6jBQbYTOsp3m826O2uEEqTUsKLYipFXfqgSpUUteDX+ueqn2NIiDyo7DTMLVQmNuEm1ZFS5F8gnsyalnj57cChFlEq80OSRNXvHRqva2Si6nn9IzMZCNDlySINw3KKZnqgjayec2V8BzImwxpg0IPEUTnnQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Mon, 10 Mar 2008 13:36:55 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080308210559.0C7A193C070@tippex.mynet.homeunix.org> <20080310085539.6815693C900@tippex.mynet.homeunix.org>
In-Reply-To: <20080310085539.6815693C900@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101336.56159.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008, Anders Eriksson wrote:
> 
> aeriksson@fastmail.fm said:
> > torvalds@linux-foundation.org said:
> >> I think we do want the bisect run here.
> >> My worry is that this is likely very timing-sensitive, so when it starts
> >> failing it might not be because of the commit that actually introduces the
> >> bug, but because some other timing changed, but with some luck that won't  
> >> be the case.
> 
> > I'm on it. Slow machine. Household's router, 4000 versions to go... 
> 
> The bisect came up with this:
> 
> 18a056feccabdfa9764016a615121b194828bc72 is first bad commit
> commit 18a056feccabdfa9764016a615121b194828bc72

Hmm, this is the first commit _after_ the previous "guilty"
commit 852738f39258deafb3d89c187cb1a4050820d555 so it just
can't be the "real bad" one...

> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Sat Jan 26 20:13:12 2008 +0100
> 
>     ide: don't enable local IRQs for PIO-in in driver_cmd_intr() (take 2)
> 
>     Don't enable local IRQs for PIO-in protocol in driver_cmd_intr().
> 
>     While at it:
> 
>     * Remove redundant rq->cmd_type check.
> 
>     * Read status register after enabling local IRQs for no-data protocol.
> 
>     v2:
>     * Re-add DRQ=1 check lost in v1 (noticed by Sergei).
> 
>     Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> :040000 040000 5fb514a261b13494c5e9c035f9e7598276ce8839 0fda2eb7d96335061741d7f54ed3e05ca34ac5b8 M      drivers
