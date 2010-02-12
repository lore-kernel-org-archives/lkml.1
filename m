Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab0BLTEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:04:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35266 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab0BLTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:13 -0500
Message-ID: <4B75A5DC.3060803@kernel.org>
Date: Fri, 12 Feb 2010 11:02:52 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jean Delvare <khali@linux-fr.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Fri, 12 Feb 2010 11:02:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 07:21 AM, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Feb 2010, Jean Delvare wrote:
>>
>> Maybe that's just me, but my main concern is neither download times nor
>> decompression times. My main concern is the access time to directory
>> indexes when browsing the kernel archive, because there are 5 entries
>> for every patch or tarball: .bz2, .bz2.sign, .gz, .gz.sign and .sign.
>> This is horribly slow.
> 
> This was actually the main reason for me personally to ask about just 
> dropping support for .gz files - not because I care deeply about how much 
> disk space kernel.org wastes, but because the long directory listings make 
> it slower for me to mentally index the directory.

It's probably worth keeping things like the .gz files around, if nothing
else for older distros, systems, etc that don't have xz yet (since it's
still relatively new)

Breaking things out into directories or such might be the easiest way
with that

v2.6/
v2.6/2.6.23
v2.6/2.6.32.6

etc

Would clean up the v2.6 directory a lot.

>> 1* Keep a single compression format. This saves almost 40% of the
>> files.
>>
>> 2* Move one of the compression formats somewhere else, so that it
>> doesn't get in the way but is still available if needed.
>>
>> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
>> related files there.
> 
> I did 3* for the testing kernels (exactly because the directory listing 
> got to be unreadable), and you just complained about it ;)
> 
> Of course, your complaint was that the subdirectory wasn't done 
> immediately, and that the old files get moved to their own subdirectory 
> later as a "archival" thing.
> 
> I just didn't want to change the location for the latest kernel.
> 
>> 4* Get rid of the LATEST-IS-* files. This is a small count, won't save
>> much, but these files seem totally useless to me these days.
> 
> Yeah, they also end up continually being stale.

Only thoughts there are that there seem to be a lot of automated
processes that rely on LATEST-IS-*.  Personally I'd rather see them snag
the RSS feed and figure out what they want from there, but that may not
be completely feasible.  It also gives a quick indication as to what's
latest in the directory and a quick search on the page usually gets me
what I'm looking for when I do it.

- John 'Warthog9' Hawley
