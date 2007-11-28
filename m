Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbXK1C3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbXK1C3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbXK1C3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:29:40 -0500
Received: from ozlabs.org ([203.10.76.45]:41088 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759808AbXK1C3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:29:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Date: Wed, 28 Nov 2007 12:36:01 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ben Elliston <bje@air.net.au>
References: <20071127001407.859743255@sgi.com> <200711271530.47696.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711271013130.2310@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711271013130.2310@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711281236.02014.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007 05:14:47 Christoph Lameter wrote:
> On Tue, 27 Nov 2007, Rusty Russell wrote:
> > Have you considered moving x86-64's setup_per_cpu_areas into generic
> > code? It's a bit messier because some archs might not have set up NUMA
> > stuff yet, but it's logically generic...
>
> Yes that will happen later. This is just the early cleanup work. I
> plan to generally bring the two x86 arches in line. The pda will be
> folded into the per cpu area and after that its easy to do.

Unfortunately, we tried to get rid of the x86-64 pda (like i386) but you lose 
the ability to use the stack protection config option.  That's because it 
assumes that gs:0x68 (or something) is the stack canary; we need a YA gcc 
change to make this gs:__builtin_stack_canary_off (where gcc can emit 
__builtin_stack_canary_off as a weak absolute symbol, so we can override it 
for the kernel.

Cheers,
Rusty.
