Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYFLEcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYFLEcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 00:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYFLEcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 00:32:36 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:54375 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYFLEcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 00:32:35 -0400
Message-ID: <4850A6DD.8070903@keyaccess.nl>
Date: Thu, 12 Jun 2008 06:32:29 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/5] x86: PAT: fix ambiguous paranoia check in pat_init()
References: <20080610140518.GF5024@alberich.amd.com> <484F065B.2050002@keyaccess.nl> <20080611094130.GA5889@alberich.amd.com> <484FCC09.7020606@keyaccess.nl> <20080611161234.GC5889@alberich.amd.com>
In-Reply-To: <20080611161234.GC5889@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-08 18:12, Andreas Herrmann wrote:

>> Again not wrong, or at least by design. Thomas Gleixner did it this way and 
>> with that "paranoia check" explicitly bombing out only for SMP this 
>> wouldn't have been by accident. He no doubt knows why he did so (and he's 
>> in CC so if we're real lucky we might also now...)
> 
> I guess at the time Thomas' patch was commited this was just fine.
> 
> But with the recent Transmeta/Centaur patch, validate_pat_support()
> returns w/o disabling PAT even for such vendor's CPUs that don't
> support PAT,

In a sense that recent patch in the x86 tree could be consired the buggy 
one as it fails to explicitly whitelist those models with functional PAT 
while THAT was the setup of things here -- but yes, don't get me wrong, 
I also think that setup wasn't particularly great.

Your followup patch turns the whitelist into a blacklist, blacklisting 
those Intel models which weren't specifically whitelisted before, which 
is a saner approach, so <shrug>. If things are ready for that, all the 
better.

Rene.
