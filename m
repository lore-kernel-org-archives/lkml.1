Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYCJPzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYCJPzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYCJPzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:55:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33719 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbYCJPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:55:23 -0400
Date: Mon, 10 Mar 2008 08:54:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <20080309114640.85c9c3eb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
 <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
 <20080309114640.85c9c3eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Andrew Morton wrote:

> - They are pretty marginal from a performance POV (iirc)

Pretty significant in our experience.

>   Making __GFP_ZERO smarter/more efficient would be a preferable way of
>   addressing any performance problems we have in there.

Looking at the page allocator "fastpath": The basic reaons that this was 
such a good optimization was that the page allocator is expensive to call. 
The hotpath gets more and more clogged with logic. Fixing the page 
allocator to be more efficient may be the right approach here. That could 
also include having a list of zeroed pages.

Zeroed pages however will not address the issue of having initialized pgd 
(which seems to be what i386 needs).

