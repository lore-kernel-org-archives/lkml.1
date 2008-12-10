Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYLJGhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYLJGhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYLJGh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:37:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50158 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbYLJGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:37:29 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       Bruno =?ISO-8859-1?Q?Pr=E9mont?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <493F2009.6060300@zytor.com>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
	 <493F2009.6060300@zytor.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 23:31:21 -0800
Message-Id: <1228894281.8766.22.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

     A. On Tue, 2008-12-09 at 17:48 -0800, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > 
> > VMI initialiation can relocate the fixmap, causing early_ioremap
> > to malfunction if it is initialized before the relocation.  The
> > ioremap area is low enough in virtual address space that no actual
> > collision occurs, however, because the pagetables for it were not
> > allocated under VMI mode, the pagetable updates are dropped by
> > the hypervisor as irrelevant, resulting in a crash on boot.
> > 
> 
> I have mentioned in the past that I think the very concept of relocating
> the fixmap to be utterly braindead.  Instead, I believe we should locate
> it low in kernel space so it doesn't have to be relocated.  It's
> unfortunately a relatively large change.

I agree, but a bit too late for 2.6.27 stable and 2.6.28-rc.

