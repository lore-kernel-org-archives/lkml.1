Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYHHAFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYHHAFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYHHAFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:05:25 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:49180 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYHHAFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g5+7H4fT46G3lcCmOrlAamid/2egP1LpIcRNd8XpOnsKFGzq25Zlo09sbI4kIzMo6T
         hSeHtcGyaEMxu/290t/iRCuhJSOGaQNAbA3/SYo7JNsBxWlnojOupn/Lkc+9YpcQCBS9
         p6wGhW55igXUfcg9GZN8qmJ7Mvy9/wf2rJwhc=
Message-ID: <e7d8f83e0808071705u32b726bjc19d8935960f37b9@mail.gmail.com>
Date: Fri, 8 Aug 2008 10:05:22 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Cc: "Pavel Machek" <pavel@suse.cz>, "Rik van Riel" <riel@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <1218119483.5837.112.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806064418.6afa0672@infradead.org>
	 <20080806141656.8B44B2FE94A@pmx1.sophos.com>
	 <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>
	 <e7d8f83e0808070721l2dd38f0dyd0366520e9131b1a@mail.gmail.com>
	 <1218119483.5837.112.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 12:31 AM, Eric Paris <eparis@redhat.com> wrote:
> On Fri, 2008-08-08 at 00:21 +1000, Peter Dolding wrote:
>
>> Also TALPA is wrong because its a LSM.   LSM are the most powerful
>> bits of the OS.   LSM are the enforcers of Linux.  They are the last
>> line of defence for the OS.   You have your normal permission systems
>> when they fail then its the job of a LSM to pick up the mess.
>
> I've been trying to ignore you, but I just can't any more.  Please dear
> god look at my work before spewing this crap.  My work is not an LSM.
> My work doesn't care about bind mounts, it cares about inodes.  My work
> is not path name based.  I'm not sure who you are trying to convince of
> something here but obviously talking about something you don't know
> about is not working for you.....
>
Path based was to using inotify that basically cannot do the job.   I
guess you agree with that.

Ok you corrected that bit in the TALPA design?   Past form of the
beast was hooking down threw the LSM structs to block files so if
something went wrong it could override all the permissions on the
system without any means of anything else blocking it.  Effectively
killing the system.   Basically the Userspace daemon answering block
everything worked.   Ie connected in too high. So key operational
files of the OS could not be protected against the scanner turning
into malware itself.   Yes users are tricked to install fake
anti-viruses and malware scanners on windows.  So yes something
hostile to the system can and most likely will connect to the TALPA
API.   Is over site to the LSM provided?  Just last time I looked
still missing.

Credentials alterations to permissions must go back threw the LSM.
Also Credentials permission change will not operate without LSM built
into kernel.   Running a Anti-virus without a wrapper around it is
partly foolish anyhow.

There is still the duplication issue.  Two filesystem caches one in
TALPA and One the FS-cache that is designed to sit on top of
Credentials.   TALPA is only a part filesystem cache but caching
approved and not approved is still a form of filesystem cache.  Its
caching virtual permissions of the filesystem.

Also duplication of permission overriding Credentials provides means
to override permissions from userspace as well including creating
virtual permissions like TALPA is doing.  Reason for virtual
permissions simple not all file system support the all the permissions
to run Linux on with LSM's fully active.

Simple fact you have two API doing almost exactly the same thing.
Just different ways.   Credentials spreed all the way threw the OS as
well.

So if in the Credential stuct was added a flag saying what version
virus scan had been done on a running executable a search of running
programs that had not been scanned against particular virus signatures
would also be simple.  Same with disconnected files.   Ie files that
have been deleted but since a process is still running are still not
deleted yet in the /proc.   TALPA cache current design cache is
nothing more than duplication beside what Credentials and FS-cache is
doing.

Also Credentials nice screw up you inode monitoring.  FS-cache on top
of Credentials can impersonate a inode.  So TALPA will think its
getting a inode from like NFS but its really getting what was stored
in the FS-cache.  So now TALPA is failed it has to scan everything to
avoid Credentials and its cache is rendered useless.

Caching of scanned and not scanned is more than doable threw the
credentials.   Scanning at the Filesystem cache itself also makes
sence.   Only 1 cache system to run also equals not exploited by
another cache running on the system.

OS hardening will required doing away with all per filesystem caches
and come back to generic cache only.  The caches currently back door
TALPA and have minor down side to Credentials.   Credentials with
FS-cache does have the option to scan everything as its loaded into
the Cache so can defend against the other caches harming it at the
cost of CPU time and ram.  Double full caching.  But since its caching
the files themselves its can not be tricked by impersonation.

TALPA is a failed design.  It has too many holes.  They need to be
closed.  Fastest way to close them is just merge its ideas into
Credentials.

Peter Dolding
