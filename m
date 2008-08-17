Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYHQXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYHQXZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYHQXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:24:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:55866 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYHQXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:24:51 -0400
Date: Sun, 17 Aug 2008 16:24:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Eric Paris <eparis@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.1.10.0808171620260.12859@asgard.lang.hm>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com>
 <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm> <20080817225844.GE21112@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Pavel Machek wrote:

>>>> And I still don't get this 'mmap problem' that I don't solve that
>>>> libmalware magically solves.  What?  don't use mmap?  I certainly hope
>>>> not.
>>>
>>> Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
>>> which is basically shared memory -- is fundamentally incompatible with
>>> reliable virus scanning.
>>>
>>> ...or do you have a reasonable solution for mmap?
>>
>>
>> mmap has a few different problems
>>
>> 1. intercepting reads and writes to take action at that time
>>
>> 2. the fact that two programs can use it as an inter-process communication
>> mechanism.
>
> ...can and will use it as an IPC. So we need to modify some
> applications.
>
> Rather than modify all the applications using mmap (you can't tell if
> the other side is going to use it for shared memory... right?), we
> could simply modify all the Windows-facing applications using mmap.
>
>> if you are worried about the IPC aspects, all you can do is forbid it,
>
> Can you automatically tell if applications are using mmap for IPC?

no, but can you tell at the time of the mmap command if anyone has it 
opened for writing? if you can then you can just not allow the mmap in 
thid case (policy decision by userspace, as such it can try to look at 
what other programs are accessing it via mmap to decide if it should allow 
it or not)

> BTW in another mail you wanted to include /var/log/syslog from
> scanning. You should not be doing that if syslog is exported to
> Windows systems. Of course, you can get away with scanning syslog when
> Windows client tries to read it, which should be acceptable...

I listed that as an example of what I would consider a sane policy. by 
doing the checking is a userspace library different binaries can be linked 
against different libraries by the sysadmin/distro to decide which ones 
need to do what checking. there's nothing inherent in the mechanism that 
foces the policy in any direction.

David Lang
