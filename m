Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYBEBPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYBEBPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYBEBPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59953 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753774AbYBEBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:07 -0500
Date: Mon, 4 Feb 2008 17:15:05 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: willy@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [git pull] SLUB updates for 2.6.25
In-Reply-To: <200802051142.20413.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0802041700170.5438@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com>
 <200802051105.12194.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802041629290.5057@schroedinger.engr.sgi.com>
 <200802051142.20413.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Nick Piggin wrote:

> Anyway, not saying the operations are useless, but they should be
> made available to core kernel and implemented per-arch. (if they are
> found to be useful)

The problem is to establish the usefulness. These measures may bring 1-2% 
in a pretty unstable operation mode assuming that the system is doing 
repetitive work. The micro optimizations seem to be often drowned out 
by small other changes to the system.

There is the danger that a gain is seen that is not due to the patch but 
due to other changes coming about because code is moved since patches 
change execution paths.

Plus they may be only possible on a specific architecture. I know that our 
IA64 hardware has special measures ensuring certain behavior of atomic ops 
etc, I guess Intel has similar tricks up their sleeve. At 8p there are 
likely increasing problems with lock starvation where your ticketlock 
helps. That is why I thought we better defer the stuff until there is some 
more evidence that these are useful.

I got particularly nervous about these changes after I saw small 
performance drops due to the __unlock patch on the dual quad. That should 
have been a consistent gain.


