Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYHQWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYHQWrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYHQWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:47:41 -0400
Received: from mail.lang.hm ([64.81.33.126]:49557 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYHQWrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:47:41 -0400
Date: Sun, 17 Aug 2008 15:47:41 -0700 (PDT)
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
In-Reply-To: <20080817221258.GC21112@atrey.karlin.mff.cuni.cz>
Message-ID: <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com>
 <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Pavel Machek wrote:

> Hi!
>
>> And I still don't get this 'mmap problem' that I don't solve that
>> libmalware magically solves.  What?  don't use mmap?  I certainly hope
>> not.
>
> Don't use mmap, it is as simple as that. AFAICS mmap(MAP_SHARED) --
> which is basically shared memory -- is fundamentally incompatible with
> reliable virus scanning.
>
> ...or do you have a reasonable solution for mmap?


mmap has a few different problems

1. intercepting reads and writes to take action at that time

2. the fact that two programs can use it as an inter-process communication 
mechanism.

if you are worried about the IPC aspects, all you can do is forbid it, 
along with shared memory, pipes, network connections, etc. none of these 
provide you with a 'final result' that can be scanned, and as others have 
pointed out there are too many ways to do things that get assembled by the 
far side to try and catch all malware in them.

as for intercepting reads and writes. the approach I outlined addresses 
this by having the kernel mark thefile as dirty if any writes happen, and 
checking the file status at the time of doing the mmap instead of trying 
to do it when the file is accessed after the mmap.

David Lang
