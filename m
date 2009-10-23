Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZJWWwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZJWWwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZJWWwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:52:16 -0400
Received: from smtp-out13.alice.it ([85.33.2.18]:1903 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZJWWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:52:16 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Oct 2009 18:52:15 EDT
Message-ID: <4AE2313B.3020901@ntd.homelinux.org>
Date: Sat, 24 Oct 2009 00:42:03 +0200
From: NiTRo <nitroml@ntd.homelinux.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       cve@mitre.org, Jamie Lokier <jamie@shareable.org>
Subject: Re: SECURITY PROBLEM: filesystem permiossion bypass on FD already
 opened
References: <4AE20B6F.4060606@ntd.homelinux.org> <20091023204442.GA7332@joi.lan> <20091023205418.GF27185@elf.ucw.cz>
In-Reply-To: <20091023205418.GF27185@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2009 22:42:05.0495 (UTC) FILETIME=[0BB46470:01CA5432]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek ha scritto:
> On Fri 2009-10-23 22:44:44, Marcin Slusarz wrote:
>   
>> On Fri, Oct 23, 2009 at 10:00:47PM +0200, NiTRo wrote:
>>     
>>> Hi to all,
>>>     Sorry for my bad english.
>>>     Just discovered this security problem on my Suse 11 (Linux xxxx
>>>       
>> You did not.
>> http://lkml.org/lkml/2009/10/23/159
>>     
>
> Actually, no, this is something different... and old/known AFAICT.
>   
Marcin, I just saw this, it's quite similar, right... But I don't fall back to /proc/self/fd for reading... I still use the same FD...

>   
>>> 2.6.25.18-0.2-pae #1 SMP 2008-10-21 16:30:26 +0200 i686 i686 i386
>>> GNU/Linux) and my Slackware 10.1.0 (Linux xxxx 2.4.29-ow1 #1 Wed Feb 2
>>> 00:05:42 CET 2005 i586 unknown unknown GNU/Linux) with OpenWall patch.
>>> If a FD is opened on a allowed file and then the permission is changed
>>> the file is still redeable starting from the already read position to
>>> the EOF.
>>>
>>> This is the scenario:
>>>
>>> <root> creates a file /tmp/aaaa with 666 permission an with the "test"
>>> string inside it
>>>         xxx:/tmp # echo test > /tmp/aaaa
>>>         xxx:/tmp # chmod 666 /tmp/aaaa
>>> <sb> opens this file hooking it in a shell as FD number 3
>>>         sb@xxx:~> bash 3< /tmp/aaaa
>>> <sb> read and prints it
>>>         sb@xxx:~> read a <&3
>>>         sb@xxx:~> echo $a
>>>         test
>>>         sb@xxx:~>
>>> ...anythig as expected...
>>> <root> changes the permissions on file to 600 and changes its content
>>> into "test o.o I cannot believe it..."
>>>         xxx:/tmp # chmod 600 /tmp/aaaa
>>>         xxx:/tmp # echo "test o.o I cannot believe it..." > /tmp/aaaa
>>> <sb> continue to try reading the file
>>>         sb@xxx:~> read a <&3
>>>         sb@xxx:~> echo $a
>>>         o.o I cannot believe it...
>>>         sb@test:~>
>>> ... and this is not expected...
>>>       
>
>
> Really? I'd expect it. I have file open for reading, you wrote
> something new to it, so I can read it back. What is the problem?
> 									Pavel
>   

I sow the second mail to... Shurely you have right... I'm sorry for this
"no-bug"...
I'd expect a read error due to permissions change... Sorry

Thanks a lot
Alessandro
