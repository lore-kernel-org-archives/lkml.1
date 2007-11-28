Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXK1Svi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXK1Svi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXK1Svb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:51:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42479 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754190AbXK1Sva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:51:30 -0500
Date: Wed, 28 Nov 2007 10:51:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ben Elliston <bje@air.net.au>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <200711281236.02014.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711271530.47696.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711271013130.2310@schroedinger.engr.sgi.com>
 <200711281236.02014.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Rusty Russell wrote:

> On Wednesday 28 November 2007 05:14:47 Christoph Lameter wrote:
> > On Tue, 27 Nov 2007, Rusty Russell wrote:
> > > Have you considered moving x86-64's setup_per_cpu_areas into generic
> > > code? It's a bit messier because some archs might not have set up NUMA
> > > stuff yet, but it's logically generic...
> >
> > Yes that will happen later. This is just the early cleanup work. I
> > plan to generally bring the two x86 arches in line. The pda will be
> > folded into the per cpu area and after that its easy to do.
> 
> Unfortunately, we tried to get rid of the x86-64 pda (like i386) but you lose 
> the ability to use the stack protection config option.  That's because it 
> assumes that gs:0x68 (or something) is the stack canary; we need a YA gcc 
> change to make this gs:__builtin_stack_canary_off (where gcc can emit 
> __builtin_stack_canary_off as a weak absolute symbol, so we can override it 
> for the kernel.

This works if you rebase the per cpu area at zero. gs:0x68 is still the 
stack canary.

The i386 method does not work because the segment register does not 
directly point to the pda.


