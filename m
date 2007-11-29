Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXK2F33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXK2F33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXK2F3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:29:21 -0500
Received: from gw.goop.org ([64.81.55.164]:35772 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXK2F3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:29:21 -0500
Message-ID: <474E4E2F.9010801@goop.org>
Date: Wed, 28 Nov 2007 21:29:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com> <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com> <474E1900.1010209@goop.org> <Pine.LNX.4.64.0711281800100.20125@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281800100.20125@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> x86_64 can use a 32 bit offset instead of a 64 bit addres because it uses 
> the small model. A load of a 64 bit address would require much more 
> expensive instructions. A load of a 64 bit address is currently avoided 
> through the use of the pda that contains the full 64 bit address in the
> data_offset field. Operations on per cpu data on x86_64 must therefore 
> first load data_offset via gs and then add the per cpu address to this
> offset. Then the per cpu operation is performed on that address.
>   

Hm.  Certainly a non-one-instruction access would be considerably less
useful than one that is, because of preemption issues.

(In general you need to pin yourself to a cpu if you're using percpu
data, but sometimes it doesn't matter.  In particular, the reason I'm
interested in this at all is because Xen puts its interrupt mask flag in
per-cpu data, and a single instruction means that masking interrupts
[=disable preemption] can be done in one instruction with no scope for
preemption in the middle doing something unexpected.)

> In order to avoid this situation through one instruction we need a small 
> 32 bit offset relative to gs. Otherwise we cannot get away from the PDA 
> and the use of data_offset.
>   

Hm, yes, I see.  Dratted large address space.  What's wrong with 4G
anyway? ;)

Anyway, I can see the problem with my thinking about this so far.

    J
