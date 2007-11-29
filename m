Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbXK2Bmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbXK2Bmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbXK2Bm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:42:27 -0500
Received: from gw.goop.org ([64.81.55.164]:43740 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbXK2Bm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:42:26 -0500
Message-ID: <474E1900.1010209@goop.org>
Date: Wed, 28 Nov 2007 17:42:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com> <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:
>
>   
>> I don't see the problem.  The way i386 does it inherently supports
>> per-cpu data very early on (it uses the prototype percpu section until
>> the real percpu values are set up).
>>     
>
> Ok so we could do that for x86_64 as well? There is more complicated 
> bootstrap since i386 does not support NUMA aware placement of per cpu 
> areas.
>   

Don't think it matters either way.  Before percpu is allocated, NUMA
issues don't matter.  Once they are - by whatever mechanism - you can
set the segment bases up appropriately.  The fact that you chose to put
percpu data at address X doesn't affect the percpu mechanism one way or
the other.

> percpu references are quite frequent already (vm statistics) and will be 
> more frequent after we have converted the per cpu arrays to per cpu 
> allocations.
>   

Well, I think the point is moot, because x86 will always use 32-bit
offsets.  Each reference will only be 1 byte bigger than a normal
variable reference.

    J
