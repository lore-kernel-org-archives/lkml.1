Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGOIMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGOIMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYGOILv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:11:51 -0400
Received: from ozlabs.org ([203.10.76.45]:43777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYGOILt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:11:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Tue, 15 Jul 2008 18:09:59 +1000
User-Agent: KMail/1.9.9
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
References: <487B05CE.1050508@jp.fujitsu.com> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com> <487C0A76.8060401@qualcomm.com>
In-Reply-To: <487C0A76.8060401@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151810.00365.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 12:24:54 Max Krasnyansky wrote:
> Heiko Carstens wrote:
> > On Mon, Jul 14, 2008 at 11:56:18AM -0700, Jeremy Fitzhardinge wrote:
> > This is asking for trouble... a config option to disable this would be
> > nice. But as I don't know which problem this patch originally addresses
> > it might be that this is needed anyway. So lets see why we need it first.
>
> How about this. We'll make this a sysctl, as Rusty already did, and set the
> default to 0 which means "never timeout". That way crazy people like me who
> care about this scenario can enable this feature.

Indeed, this was my thought too.  s390 can initialize it to zero somewhere in 
their boot code.

> btw Rusty, I just had this "why didn't I think of that" moments. This is
> actually another way of handling my workload. I mean it certainly does not
> fix the root case of the problems and we still need other things that we
> talked about (non-blocking module delete, lock-free module insertion, etc)
> but at least in the mean time it avoids wedging the machines for good.
> btw I'd like that timeout in milliseconds. I think 5 seconds is way tooooo
> long :).

We can make it ms, sure.  200ms should be plenty of time: worst I ever saw was 
150ms, and that was some weird Power box doing crazy stuff.  I wouldn't be 
surprised if you'd never see 1ms on your hardware.

The ipi idea would handle your case a little more nicely, too, but that's 
probably not going to hit this merge window.

Cheers,
Rusty.
