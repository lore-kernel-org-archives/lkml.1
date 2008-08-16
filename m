Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYHPJrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYHPJrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 05:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHPJrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:47:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36721 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751632AbYHPJrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:47:31 -0400
Date: Sat, 16 Aug 2008 10:28:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, Peter Dolding <oiaohm@gmail.com>,
       rmeijer@xs4all.nl, capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080816102846.37b104a7@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0808152115210.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	<e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	<alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	<e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
	<20080815210942.4e342c6c@infradead.org>
	<alpine.DEB.1.10.0808152115210.12859@asgard.lang.hm>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really think that we need to avoid trying to have a single 'known good' 
> flag/generationnrwith the inode.

I don't think we should have anything in the inode. We don't want to
bloat inode objects for this cornercase.

> if you store generation numbers for individual apps (in posix attributes 
> to pick something that could be available across a variety of 
> filesystems), you push this policy decision into userspace (where it

Agreed
 
> 1. define a tag namespace associated with the file that is reserved for 
> this purpose for example "scanned-by-*"

What controls somewhat writing such a tag on media remotely ? Locally you
can do this (although you are way too specialized in design - an LSM hook
for controlling tag setting or a general tag reservation sysfs interface
is more flexible than thinking just about scanners.

> 2. have an kernel option that will clear out this namespace whenever a 
> file is dirtied

That will generate enormous amounts of load if not carefully handled.

> 3. have a kernel mechanism to say "set this namespace tag if this other 
> namespace tag is set" (this allows a scanner to set a 'scanning' tag when 
> it starts and only set the 'blessed' tag if the file was not dirtied while 

User space problem. Set flags 'dirty', then set bit 'scanning'
clear 'dirty' then clear 'scanning' when finished. If the dirty flag got
set while you were scanning it will still be set now you've cleared you
scanning flag. Your access policy depends upon your level of paranoia (eg
"dirty|scanning == BAD")

> programs can set the "scanned-by-*" flags on that the 'libmalware' library 

We've already proved libmalware doesn't make sense

> L. the fact that knfsd would not use this can be worked around by running 
> FUSE (which would do the checks) and then exporting the result via knfsdw

Not if you want to get any work done.

> what did I over complicate in this design? or is it the minimum feature 
> set needed?
> 
> are any of the features I list impossible to implement?

Go write it and see, provide benchmarks ?  I don't see from this how you
handled shared mmap ?


