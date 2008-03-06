Return-Path: <linux-kernel-owner+w=401wt.eu-S933946AbYCFNwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbYCFNwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbYCFNw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:52:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:5077 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYCFNw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:52:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=klLKL4qlGWZ6+roTK40NsC6xvu3/1aKOufggaMaP2NP4CBvfdW/Sm4qCnWU3/ibuctnXskmMYP0r+AoBKsFoWTkhew2g+qsg5lt9aOoVX6Q26C6ZluLwQem3uVnlbFxWK4DxJg9DprjEacrLfid8BHcCExRIkBUg+qAt4taeWIU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.25-rc4
Date: Thu, 6 Mar 2008 15:06:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Anders Eriksson <aeriksson@fastmail.fm>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu>
In-Reply-To: <20080306133347.GA23495@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803061506.19449.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008, Ingo Molnar wrote:
> 
> * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > The problem looks very similar to the one recently reported by Anders:
> > 
> > http://lkml.org/lkml/2008/2/22/239
> > 
> > "Trying out 2.6.25-rc2 smartd always causes my box to hang. I can 
> > switch vt:s and the keyboard seems to work.
> > 
> > Using sysrq-e I noticed a callpath open -> ext3 -> journals -> 
> > sync_buffer -> io_scheduel -> generic_unplig_device. I'd guess the 
> > open stems from smartd. Removing smartd from the startup, I'm now 
> > using rc2 fine..."
> > 
> > Initially we thought that it is an IDE regression but after some 
> > testing and further investigation it seems that IDE changes just made 
> > it more likely to occur (yesterday it turned out that the kernel with 
> > the "guilty" IDE commit sometimes boots fine).  The issue is easily 
> > reproducible.
> > 
> > PS We've already verified that it is not PREEMPT related or a compiler 
> > bug.
> 
> smartd is not active here though - and starting/restarting it doesnt 
> provoke a hang.

I was a bit unclear on this, the problem is easily reproducible but _only_
on Anders' system (I couldn't reproduce it with smartd here either).

Thanks,
Bart
