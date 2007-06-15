Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXFOAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXFOAT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXFOATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:19:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43488
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXFOATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:19:47 -0400
Date: Thu, 14 Jun 2007 17:18:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
cc: greg@kroah.com, agruen@suse.de, sds@tycho.nsa.gov, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <467193FD.3010803@hawkeye.stone.uk.eu.org>
Message-ID: <Pine.LNX.4.64.0706141717320.29630@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <20070610083427.GA24808@elf.ucw.cz> <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
 <20070610210547.GC25138@elf.ucw.cz> <Pine.LNX.4.64.0706102322490.6675@asgard.lang.hm>
 <467193FD.3010803@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Jack Stone wrote:

> david@lang.hm wrote:
>> On Sun, 10 Jun 2007, Pavel Machek wrote:
>>> But you have that regex in _user_ space, in a place where policy
>>> is loaded into kernel.
>>
>> then the kernel is going to have to call out to userspace every time a
>> file is created or renamed and the policy is going to be enforced
>> incorrectly until userspace finished labeling/relabeling whatever is
>> moved. building this sort of race condigion for security into the kernel
>> is highly questionable at best.
>>
>>> AA has regex parser in _kernel_ space, which is very wrong.
>>
>> see Linus' rants about why it's not automaticaly the best thing to move
>> functionality into userspace.
>>
>> remember that the files covered by an AA policy can change as files are
>> renamed. this isn't the case with SELinux so it doesn't have this sort
>> of problem.
>
> How about using the inotify interface on / to watch for file changes and
> updating the SELinux policies on the fly. This could be done from a
> userspace daemon and should require minimal SELinux changes.
>
> The only possible problems I can see are the (hopefully) small gap
> between the file change and updating the policy and the performance
> problems of watching the whole system for changes.

as was mentioned by someone else, if you rename a directory this can 
result in millions of files that need to be relabeled (or otherwise have 
the policy changed for them)

that can take a significant amount of time to do.

David Lang
