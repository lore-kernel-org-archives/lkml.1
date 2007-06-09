Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXFIHFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXFIHFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXFIHFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:05:18 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51963
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXFIHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:05:16 -0400
Date: Sat, 9 Jun 2007 00:04:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname
 matching
In-Reply-To: <20070609014454.2f1f2f91.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
 <20070608232531.d68de09f.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
 <20070609011022.ac332fc7.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
 <20070609014454.2f1f2f91.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:

>> so are you suggesting that SELinux would call out to userspace for every
>> file open to get the label for that file?
>>
>
> No, i'm not.  You must already have a kernel function in the current
> implementation of AA that decides the proper policy for each path.  Why
> not use it  to feed labels into SELinux.

if it was this easy just have SELinux set the label == path

you first need to figure out what the path is. right now this can't be 
done, the AA paches provide this capability.

second, the AA policies aren't based just on the path, they are based on 
the program accessing the path, then the path. you can have two different 
policies for two different programs accessing the same path, but for most 
programs (although, not nessasarily most activity) there will be no 
policy, and therefor no need to check the path.

but even if you did these things, why would it be an advantage to use a 
mechanism to create a dummy label and pass it off to different code rather 
then just decideing at that point? once the AA code knows what the policy 
for this path is for this program (which it would need to know to set the 
label) how is it a win to pass this off to another chunk of code? you 
would also need to make sure that the SELinux code didn't try to cache the 
label for future use either, becouse in the future the access may be from 
another program and so the policy that's needed is different.

David Lang
