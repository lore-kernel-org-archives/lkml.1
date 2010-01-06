Return-Path: <linux-kernel-owner+w=401wt.eu-S932584Ab0AFUoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0AFUoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025Ab0AFUoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:44:12 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55189 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab0AFUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:44:10 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAN6EREurR7Ht/2dsb2JhbADAAZNghDAE
X-IronPort-AV: E=Sophos;i="4.49,231,1262563200"; 
   d="scan'208";a="462635467"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>,
       David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] log2.h: Macro-ize is_power_of_2() for use in BUILD_BUG_ON
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	<20100106123306.ac85e557.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 12:44:05 -0800
In-Reply-To: <20100106123306.ac85e557.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 6 Jan 2010 12:33:06 -0800")
Message-ID: <aday6kbt14a.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 20:44:05.0437 (UTC) FILETIME=[FCA486D0:01CA8F10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Perhaps we can avoid worrying about that via

 > #define BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
 > 	BUILD_BUG_ON((n != 0 && ((n & (n - 1)) == 0)))

Having something so specific to this particular case makes me feel like
maybe it's just not worth it.  At least in the case I'm looking at, we
could just have:

/*
 * The code relies on FOO being a power of 2.  If you break this,
 * you're dumb.
 */
#define FOO_SHIFT	6
#define FOO		(1 << FOO_SHIFT)

Your thoughts?

 - R.
