Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYCISUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYCISUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYCISUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:20:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51106 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYCISUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:20:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Sun, 9 Mar 2008 19:19:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "LKML" <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Adam Belay" <abelay@novell.com>, "Lee Revell" <rlrevell@joe-job.com>,
       "Pavel Machek" <pavel@ucw.cz>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <20080306092730.4412d085@mjolnir.drzeus.cx> <20080309151659.63d54f38@mjolnir.drzeus.cx>
In-Reply-To: <20080309151659.63d54f38@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091919.25465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of March 2008, Pierre Ossman wrote:
> I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.
> 
> In case anyone else has any more ideas, I'll detail what I've found influences the noise:
> 
> 1. C state
> 
> This is the big one. There is no noise as long as C3 is avoided (processor.max_cstate).
> 
> 2. uhci_hcd driver
> 
> USB is somehow involved in this problem. Unloading the uhci_hcd driver almost
> entirely kills the noise on a 1000 HZ NO_HZ kernel. On a 100 HZ, no NO_HZ
> kernel, the effect is very small, but still there.  
> 
> 3. Low speed USB devices
> 
> Related, the noise goes away if I insert a USB mouse (low speed).
> A high-speed device does not effect the noise, neither does the two built-in
> low speed devices (a fingerprint reader and a bluetooth host).  
> 
> 4. Battery and AC
> 
> The noise increases with the battery present and also when the AC supply is
> removed. 
> 
> 5. Second core
> 
> Disabling the second core makes the noise go away. This might be
> a subset of 1., as I've been told that a stopped core enters C1. 
> 
> 
> Changing HZ and NO_HZ has no noticeable effect on the problem (except
> the odd behaviour in 2.). This is further supported by the fact that Windows
> also has the problem (which should behave close to 100 HZ without NO_HZ).  
> 
> 
> So for now, the only viable workaround is processor.max_cstate....

Well, there may be some users willing to trade some battery life for having a
quiet box. :-)

Perhaps it's worth documenting?

Thanks,
Rafael
