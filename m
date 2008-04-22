Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbYDVJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbYDVJtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYDVJtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:49:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:37716 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144AbYDVJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Yw9/A2U62acv7QczEHmHGTixBVr7cZvrKXO7Iqz2+oBX65YktrNAIQ6sVFbS4IdPLgslixdD9fPmZ74xtyyUl9wwome7yCL42VpZtDZUOL51Hnw1/cU0bYBfJYcDQaFHuk4ZVh2cHyI1GCsizEoDTaXFqWf6wgajqitb7yujrfk=
Message-ID: <480DB493.6080004@gmail.com>
Date: Tue, 22 Apr 2008 11:49:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       mingo@elte.hu
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds napsal(a):
> 
> On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
>>> The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
>>> give slab a try. Any other clues?
>> Well, SLUB uses some per CPU data structures.  Is it possible that they get
>> corrupted and which leads to the observed symptoms?
> 
> It really doesn't look like the slub allocations themselves would be 
> corrupted. It very much looks like wild pointers corrupting allocations 
> that themselves were fine.

Hmm, correct.

> What do you do to trigger this? Any particular load? Is it still just 
> doing suspend/resume, or do you have something else that you are playing 
> with?

Yesterday I did 2 suspend/resumes after 1 hour of uptime and ran git-status 
for a fraction of a second until it was killed. So I can perfectly reproduce 
it when I suspend, resume and produce some io load. I guess it's time to 
bisect 2.6.25-rc8-mm2 as I'm able to reproduce it the best and haven't seen 
that bug in -rc8-mm1 for over week of suspending and working.

> Also, have you tried CONFIG_DEBUG_PAGEALLOC? That can also be a very 
> powerful way to find memory corruption.

Not yet.

> Does anybody see any other patterns? Looking at the modules linked in in 
> the oopses from Zdenek, Rafael and Jiri, I don't see anything odd. You 
> both all have 80211 support, maybe the corruption comes from the wireless 
> layer?

May be, however I don't use that stack, it's a desktop machine, it's only 
sitting there not turned on, but sure, it's loaded.
