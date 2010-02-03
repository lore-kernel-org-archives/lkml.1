Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0BCSsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:48:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:35905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0BCSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:48:18 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100203181425.GB1367@aftab>
References: <20100130094515.475881280@intel.com>
	 <20100130094957.692671259@intel.com>
	 <20100201124825.cc024f2a.akpm@linux-foundation.org>
	 <20100203133951.GA24357@localhost>
	 <20100203070825.e36b3932.akpm@linux-foundation.org>
	 <1265210157.24455.646.camel@laptop>
	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
	 <20100203181425.GB1367@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 19:47:55 +0100
Message-ID: <1265222875.24455.1020.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 19:14 +0100, Borislav Petkov wrote:

> alternative("call hweightXX", "popcnt", X86_FEATURE_POPCNT)

Make sure to apply a 0xff bitmask to the popcnt r16 call for hweight8(),
and hweight64() needs a bit of magic for 32bit, but yes, something like
that ought to work nicely.

