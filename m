Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbYDVR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbYDVR0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbYDVR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:26:12 -0400
Received: from sandeen.net ([209.173.210.139]:31388 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762792AbYDVR0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:26:07 -0400
Message-ID: <480E1FAE.20509@sandeen.net>
Date: Tue, 22 Apr 2008 12:26:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: #define out unused parameters of	xfs_bmap_add_free
 and xfs_btree_read_bufl
References: <20080419142329.GA5339@elte.hu> <200804221320.54147.vda.linux@googlemail.com> <20080422142807.GD16895@cs181133002.pp.htv.fi> <200804221817.03945.vda.linux@googlemail.com> <20080422172156.GB28933@cs181133002.pp.htv.fi>
In-Reply-To: <20080422172156.GB28933@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Apr 22, 2008 at 06:17:03PM +0200, Denys Vlasenko wrote:


>>> Elimination of completely unused parameters makes sense, but IMHO using 
>>> such #define hacks for minuscule code size and stack usage advantages is 
>>> not worth it.
>> In busybox this trick is used extensively.
> 
> Busybox does not have more than one million lines changed in
> one release.
> 
> In the Linux kernel maintainability is much more important than in 
> smaller projects.
> 
>> I don't know how to eliminate these unused parameters with less
>> intervention, but I also don't want to leave it unfixed.
>>
>> I want to eventually reach the state with no warnings
>> about unused parameters.
> 
> The standard kernel pattern in using empty static inline functions (that 
> allow type checking).
> 
> And I'm not sure whether the number of functions you'd have to change 
> for reaching your goal has four, five or six digits.

It would be a huge undertaking.

Just building xfs w/ the warning in place exposes tons of unused
parameter warnings from outside xfs as well.

But, if it was deemed important enough, you could go annotate them as
unused, I suppose, and hack away at it...  Does marking as unused just
shut up the warning or does it let gcc do further optimizations?

-Eric
