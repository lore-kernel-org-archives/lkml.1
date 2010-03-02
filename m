Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0CBXbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:31:18 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55586 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0CBXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:31:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Memory management woes - order 1 allocation failures
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
In-Reply-To: <20100302183451.75d44f03@lxorguk.ukuu.org.uk>
References: <20100302172606.GA11355@csn.ul.ie> <20100302183451.75d44f03@lxorguk.ukuu.org.uk>
Message-Id: <20100303082239.D614.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  3 Mar 2010 08:31:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For reasons that are not particularly clear to me, tty_buffer_alloc() is
> > called far more frequently in 2.6.33 than in 2.6.24. I instrumented the
> > function to print out the size of the buffers allocated, booted under
> > qemu and would just "cat /bin/ls" to see what buffers were allocated.
> > 2.6.33 allocates loads, including high-order allocations. 2.6.24
> > appeared to allocate once and keep silent.
> 
> The pty layer is using them now and didn't before. That will massively
> distort your numhers.
> 
> > While there have been snags recently with respect to high-order
> > allocation failures in recent kernels, this might be one of the cases
> > where it's due to subsystems requesting high-order allocations more.
> 
> The pty code certainly triggered more such allocations. I've sent Greg
> patches to make the tty buffering layer allocate sensible sizes as it
> doesn't need multiple page allocations in the first place.

Wow, great! :)


