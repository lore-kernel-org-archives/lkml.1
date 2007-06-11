Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbXFKG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbXFKG3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXFKG3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:29:03 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34006
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXFKG3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:29:00 -0400
Date: Sun, 10 Jun 2007 23:27:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070610210547.GC25138@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706102322490.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <20070610083427.GA24808@elf.ucw.cz> <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
 <20070610210547.GC25138@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Pavel Machek wrote:

>>>> extended out this can come close to giving each file it's own label. AA
>>>> essentially does this and calls the label the path and computes it at
>>>> runtime instead of storing it somewhere.
>>>
>>> Yes, and in the process, AA stores compiled regular expressions in
>>> kernel. Ouch. I'll take "each file it's own label" over _that_ any time.
>>
>> and if each file has it's own label you are going to need regex or similar
>> to deal with them as well.
>
> But you have that regex in _user_ space, in a place where policy
> is loaded into kernel.

then the kernel is going to have to call out to userspace every time a 
file is created or renamed and the policy is going to be enforced 
incorrectly until userspace finished labeling/relabeling whatever is 
moved. building this sort of race condigion for security into the kernel 
is highly questionable at best.

> AA has regex parser in _kernel_ space, which is very wrong.

see Linus' rants about why it's not automaticaly the best thing to move 
functionality into userspace.

remember that the files covered by an AA policy can change as files are 
renamed. this isn't the case with SELinux so it doesn't have this sort of 
problem.

David Lang
