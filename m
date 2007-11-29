Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXK2CGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXK2CGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbXK2CGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:06:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34947 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758023AbXK2CGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:06:07 -0500
Date: Wed, 28 Nov 2007 18:06:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474E1900.1010209@goop.org>
Message-ID: <Pine.LNX.4.64.0711281800100.20125@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
 <474E1900.1010209@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:

> > percpu references are quite frequent already (vm statistics) and will be 
> > more frequent after we have converted the per cpu arrays to per cpu 
> > allocations.
> >   
> 
> Well, I think the point is moot, because x86 will always use 32-bit
> offsets.  Each reference will only be 1 byte bigger than a normal
> variable reference.

Just because i386 is not able to use it does not mean that other arches 
are not. F.e. IA64 can embedd offsets in the actual instruction (but of 
course not 64bit).

x86_64 can use a 32 bit offset instead of a 64 bit addres because it uses 
the small model. A load of a 64 bit address would require much more 
expensive instructions. A load of a 64 bit address is currently avoided 
through the use of the pda that contains the full 64 bit address in the
data_offset field. Operations on per cpu data on x86_64 must therefore 
first load data_offset via gs and then add the per cpu address to this
offset. Then the per cpu operation is performed on that address.

In order to avoid this situation through one instruction we need a small 
32 bit offset relative to gs. Otherwise we cannot get away from the PDA 
and the use of data_offset.

 
