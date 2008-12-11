Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYLKEut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYLKEut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLKEuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:50:40 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60554 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYLKEuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:50:40 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       Bruno =?ISO-8859-1?Q?Pr=E9mont?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <49405CB6.6010006@kernel.org>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
	 <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com>
	 <49405CB6.6010006@kernel.org>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 21:44:32 -0800
Message-Id: <1228974272.8766.59.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 16:20 -0800, Yinghai Lu wrote:
> it seems still have some problem.
> you moved reserve_top_address before parse_parameter...

I really only care about resetting fixmap_top.  Adding more vmalloc
space to accomodate what we stole is just being nice... in practice this
should not be a problem.

> __VMALLOC_RESERVE will be overwriten by vmalloc=...
> 
> you may need to split reserve_top_address() to two functions...

For now, misuse vmalloc=XXX at your own risk - why the need for it
anyway?

I agree, it should be cleaned up, as HPA suggests, we should move the
fixmap to a fixed place anyways, and have vmalloc area from the top of
linear memory down to the end of the physical memory mapping.  But there
really isn't time to do anything better for 2.6.28.

Zach

