Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbZAUKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbZAUKHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZAUKHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:07:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:51965 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZAUKHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:07:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,299,1231142400"; 
   d="scan'208";a="102245773"
Subject: Re: hardware time stamping with optional structs in data area
From: Patrick Ohly <patrick.ohly@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
	 <1232102164.18762.72.camel@pohly-MOBL>
	 <20090116.110033.163815590.davem@davemloft.net>
In-Reply-To: <20090116.110033.163815590.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain
Date: Wed, 21 Jan 2009 11:07:37 +0100
Message-Id: <1232532457.7829.19.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 21:00 +0200, David Miller wrote: 
> From: Patrick Ohly <patrick.ohly@intel.com>
> Date: Fri, 16 Jan 2009 11:36:04 +0100
> 
> > David, do you think it is ready to get included?
> 
> Resubmit the patch set before asking such questions.

Okay. I didn't want to spam the lists with just rebased patches if there
were more fundamental objections against the current approach. I hope
that this is no longer the case, so I'll post the current, rebased patch
set as follow-up to this mail (because the description in the orginal
mail of this thread still applies).

I personally consider the core infrastructure patches ready. If there
are further comments I'd be happy to work on those, of course. The igb
driver patches are more experimental, please don't include them.

I rebased the patches against net-next-2.6 as of today.

I tested them with the modified PTPd with and without hardware support
on x86. With 64 bit kernel and user space both works. With 32 bit user
space on a 64 bit kernel software-only time stamping works (thanks to
the socket's compatibility layer), hardware support doesn't: the ifreq
is passed to the right device driver, but the data pointer from a 32 bit
process is not interpreted correctly by a 64 bit driver. If there is a
way to handle this then please let me know - I didn't see how a device
driver could distinguish between a 32 and 64 bit user process.

With a 32 bit kernel software time stamping works. I couldn't test
hardware support because I couldn't get the igb driver to work. Even
without any of the patches it failed to transmit packets (tested with
net-next-2.6 sources and original Ubuntu 8.10 installation). I need to
look into this problem further, but don't want to hold up the review of
the patches.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

