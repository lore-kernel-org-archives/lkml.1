Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZDKUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZDKUMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZDKUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:12:03 -0400
Received: from mga07.intel.com ([143.182.124.22]:24207 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755067AbZDKUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:12:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,173,1239001200"; 
   d="scan'208";a="130449062"
Message-ID: <49E0F98C.1090202@linux.intel.com>
Date: Sat, 11 Apr 2009 13:11:56 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Heinz Diehl <htd@fancy-poultry.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain> <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain> <49E0EC87.9080808@linux.intel.com> <alpine.LFD.2.00.0904111247320.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111247320.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 11 Apr 2009, Arjan van de Ven wrote:
>> Now that I've been able to scan most of my mail; it looks like the one-liner
>> should just go in.
> 
> Ok, I committed my one-liner, and then also reverted the ACPI battery 
> workaround of removing __init, since the one-liner should fix that too.
> 
> Cc'ing the people involved with that commit, just so that they know to 
> test to make sure the alternate fix really did fix it for them (I'm pretty 
> sure it does, but still a good idea to verify or at least let people know 
> that a previous fix got reverted)

longer term I would like to work on two things
1) Fix the __init thing by just only freeing when appropriate, but not having to wait for it
2) Find a way for userland to trigger a sync
    - for all storage probing
    - for just async work
    - "global sync", which includes all driver init
    We can then have insmod/modprobe use this always, unless a flag is set
    (so say, udev, can load a slew of modules, and then sync only on the last one)

and then after a year or two we can maybe remove the sync from the module loader ;(
