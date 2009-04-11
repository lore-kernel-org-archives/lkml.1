Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZDKUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZDKUFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZDKUFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:05:46 -0400
Received: from mga12.intel.com ([143.182.124.36]:52661 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755584AbZDKUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:05:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,173,1239001200"; 
   d="scan'208";a="130448343"
Message-ID: <49E0F805.2090502@linux.intel.com>
Date: Sat, 11 Apr 2009 13:05:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@lists.linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain> <49DFFC05.7070509@linux.intel.com> <200904112138.26518.rjw@suse.com> <alpine.LFD.2.00.0904111253520.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111253520.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 11 Apr 2009, Rafael J. Wysocki wrote:
>> FWIW, I applied the appended patch and it fixed the problem for me.
> 
> I think that patch is probably the right thing to do regardless, but I 
> also think it doesn't obviate the need for also doing so at module loading 
> time. 
> 
> I'm pretty sure that calling scsi_complete_async_scans() won't protect 
> against an async USB bus scan, for example.

but neither does anything else we have in the kernel right now.......
(specifically, USB does not use the async infrastructure)

> But I do think your patch is probably worth doing anyway.

Absolutely; I wonder if we should make a more generic "wait for async storage scans"
function, that just calls this one, but allows other systems to also be in there.
(although.. right now I'd not know which ones it would be).



