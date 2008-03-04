Return-Path: <linux-kernel-owner+w=401wt.eu-S1763754AbYCDKln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763754AbYCDKln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYCDKld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:41:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:56401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbYCDKld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:41:33 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: early_res and find_e820_area for i386?
Date: Tue, 4 Mar 2008 11:41:28 +0100
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1204601883.4707.96.camel@caritas-dev.intel.com>
In-Reply-To: <1204601883.4707.96.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041141.28404.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 04:38:03 Huang, Ying wrote:

> Is it better to implement early_res and find_e820_area on i386? Can we
> trust E820 table on i386?

The 64bit code is certainly more flexible and cleaner, but also
much more complicated.. But on the other hand i386 has simpler requirements 
so it didn't really need the full power. I didn't think that had changed.

The key change if you wanted to do that would be to change all the unsigned longs to
pfns -- the 64bit code is not all together 32bit clean. Or perhaps better
pfns + page offset since some of the allocations don't need to be page aligned
and would waste memory if they were forced to pfns.

An alternative might be to use the new allocators only for <4GB
on i386 and keep handling >4GB in some other way.

-Andi
