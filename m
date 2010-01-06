Return-Path: <linux-kernel-owner+w=401wt.eu-S932856Ab0AFVXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0AFVXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0AFVXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:23:14 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:5452 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab0AFVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:23:14 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAA+OREurR7Hu/2dsb2JhbAC/a5NkhDAE
X-IronPort-AV: E=Sophos;i="4.49,231,1262563200"; 
   d="scan'208";a="285573350"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] log2.h: Macro-ize is_power_of_2() for use in BUILD_BUG_ON
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 13:23:13 -0800
In-Reply-To: <20100106123306.ac85e557.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 6 Jan 2010 12:33:06 -0800")
Message-ID: <ada8wcbszb2.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 21:23:13.0546 (UTC) FILETIME=[743986A0:01CA8F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > We've had recurring struggles with various versions of gcc screwing up
 > constructs of this form and trying to emit the non-constant code when
 > the arg was clearly a compile-time constant.  One episode which comes
 > to mind was when we made changes to kmalloc().
 > 
 > Of course, that might not bite us in this case - it would need a lot of
 > coverage testing to find out.

Actually, after thinking about this a bit more I don't think this is
much of a risk in this case.  The bad case is where gcc gets the wrong
answer for __builtin_constant_p(), and in that case, we're left with the
status quo ante, ie a call to the original inline function implementation.

This will break a call to BUILD_BUG_ON() but that's visible at compile
time.  It's hard to think of a silent failure case that actually hurts
anything -- the macro and inline implementation are identical, except
that the macro implementation will work when gcc really needs a compile
time constant.

 - R.
