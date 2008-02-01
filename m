Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbYBALHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbYBALHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYBALHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:07:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:38496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYBALHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:07:37 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/4] x86: set_memory_xx enhancement
Date: Fri, 1 Feb 2008 12:07:29 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1201858492.4051.18.camel@caritas-dev.intel.com>
In-Reply-To: <1201858492.4051.18.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011207.29626.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 10:34:52 Huang, Ying wrote:
> This patch makes set_memory_xx can be used on arbitrary memory mapping
> (besides identity mapping), such as memory mapped with ioremap. The
> physical address is added to the set_memory_xx functions as another
> parameter.

Well as you can see it's incredible complicated. And it's not even 
needed because there is no need to change the direct mapping and 
add more TLB misses for all users who happen to share the same 2MB area 
just to get an executable mapping somewhere. All this effort is only
really needed for uncacheable mappings where the architecture requires
coherency. Or for mappings where cache coherency is not ensured.

It would be much simpler to just fix ioremap to allow executable
mappings again. And remove set_memory_x() again because it is much
less efficient than ioremap for this.


-Andi
