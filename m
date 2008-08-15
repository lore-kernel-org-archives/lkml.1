Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYHOFXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYHOFXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYHOFXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:23:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:42015 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYHOFXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:23:13 -0400
Date: Thu, 14 Aug 2008 22:22:45 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon
 access scanning
In-Reply-To: <1218769209.16613.31.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808142212430.12859@asgard.lang.hm>
References: <20080813125638.GB6995@ucw.cz>  <20080813135207.CC08C3765BC@pmx1.sophos.com>  <20080814125410.GA2262@elf.ucw.cz>  <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>  <20080814223918.GC6370@elf.ucw.cz>  <20080814200005.6b363716@bree.surriel.com>
 <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Eric Paris wrote:

>> But Pavel is raising a good question.  In Eric's proposed threat
>> model, he claimed the only thing that he was trying to solve was
>> "scanning".  Just file scanning.  That implies no root privileges, but
>> it also implied that he wasn't worried about malware running with user
>> privileges, either.  Presumbly, that would be caught and stopped by
>> the file scanner before the malware had a chance to run; that is the
>> execve(2) system call would also be blocked until the executable was
>> scanned.
>>
>> So if that is the threat model, then the only thing libmalware.so
>> doesn't solve is knfsd access, and it should be evaluated on that
>> basis.  If the threat model *does* include malware which is **not**
>> caught by the AV scanner, and is running with user privileges, then
>> there are a whole host of other attacks that we have to worry about.
>> So let's be real clear, up front, what the threat model is, and avoid
>> changing the model around to rule out solutions that don't fit the
>> initially preconceived one.  That's how you get to the TSA
>> confiscating water bottles in airport security lines.
>
> No, I'm not claiming to protect against running processes.  I'll leave
> that for SELinux.
>
> I haven't seen this supposed libmalware.so so take anything I say with a
> grain of sand.  But I take it that the solutions to the problems are
> 'don't do that.'

libmalware.so is shorthand for 'have a userspace library do the scanning 
and handle the open'

> aka malware is allowed to flow freely across linux nfs servers.  Great,
> I'm sure corperate IT organizations are going to love knowing there
> isn't a darn thing they can do to protect their nfs server from being
> storage grounds other than hope they can control all of the border.

nfs isn't secure anyway so you better control the border.

it's only the kernel nfs daemon that won't use the library, so the answer 
is don't use that daemon. I beleive that there is a FUSE NFS option, or if 
nothing else, mount a filesystem with FUSE (linked against libmalware.so) 
and then export the result vi knfsd.

> And I still don't get this 'mmap problem' that I don't solve that
> libmalware magically solves.  What?  don't use mmap?  I certainly hope
> not.

libmalware can intercept the mmap call and decide to either prohibit it, 
copy the file so that the program is operating from it's own copy, or do 
something else (all dependant on policy, as defined in userspace for this 
library)

> Are we seriously considering that the right thing to do is to try to
> push malware scanning to every project on sourceforge?  At least putting
> a solution inside glibc wasn't completely insane, I just think for
> numerous reasons we've seen on list for the last 2 weeks not a better
> idea.  In any case, having an application have to make special calls to
> handle 'untrusted' data is basically like turning the keys to the castle
> over on every exploit.  No, I might not make promises about subverted
> applications, but that doesn't mean I have to just open all the doors.
> And anything that requires explicit application help is just that.  Talk
> about theater.

libmalware.so and a modified glibc are not mutually exclusive. you distros 
could offer versions of glibc that include libmalware.

again, libmalware.so is not referring to any specific body of code, it's 
referring to the concept that the handling of open/mmap/read/etc and 
scanning is done via a userspace library rather then by the kernel. if 
everyone can agree on that concept then hashing out the details of _which_ 
library it gets put in is a smaller detail.

this isn't designed to require every app that wants this protection to 
have to change it's code.

David lang
