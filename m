Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbYJEPGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbYJEPGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYJEPGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:06:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:54193 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754066AbYJEPGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,363,1220252400"; 
   d="scan'208";a="623576894"
Message-ID: <48E8D7A5.7060508@linux.intel.com>
Date: Sun, 05 Oct 2008 08:05:09 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, david.graham@intel.com, bruce.w.allan@intel.com,
       john.ronciak@intel.com, chris.jones@canonical.com,
       tim.gardner@canonical.com, airlied@gmail.com, Olaf Kirch <okir@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>  <200810021523.45884.jbarnes@virtuousgeek.org>  <20081003.134634.240211201.davem@davemloft.net>  <200810031429.22598.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0810032338140.26779@jikos.suse.cz>  <4807377b0810031628x43f79eferdbb9c9c264a5816e@mail.gmail.com>  <alpine.LNX.1.10.0810041219130.26779@jikos.suse.cz>  <alpine.LFD.2.00.0810041236250.4404@apollo> <4807377b0810041824u5ea472d1q4cf5ff606bd23a11@mail.gmail.com> <alpine.LFD.2.00.0810050959420.3398@apollo>
In-Reply-To: <alpine.LFD.2.00.0810050959420.3398@apollo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 4 Oct 2008, Jesse Brandeburg wrote:
>>> Exactly. The access to a ro region results in a fault. I have nowhere
>>> seen that trigger, but I can reproduce the trylock() WARN_ON, which
>>> confirms that there is concurrent access to the NVRAM registers. The
>>> backtrace pattern is similar to the one you have seen.
>> are you still getting WARN_ON *with* all the mutex based fixes already applied?
> 
> The WARN_ON triggers with current mainline. Is there any fixlet in
> Linus tree missing ?
> 
>> with the mutex patches in place (without protection patch) we are
>> still reproducing the issue, until we apply the set_memory_ro patch.
> 
> That does not make sense to me. If the memory_ro patch is providing
> _real_ protection then you _must_ run into an access violation. If not,
> then the patch just papers over the real problem in some mysterious
> way.
> 

not if the bad code is doing copy_to_user .... (or similar)
