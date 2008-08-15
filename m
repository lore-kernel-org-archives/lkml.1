Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYHOFN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYHOFN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYHOFNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:13:21 -0400
Received: from saeurebad.de ([85.214.36.134]:48112 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYHOFNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:13:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
References: <20080813192922.GI8232@mit.edu>
	<20080814093103.6CD102FE8B4@pmx1.sophos.com>
	<20080814132455.GE6469@mit.edu>
	<1218721713.3540.125.camel@localhost.localdomain>
	<20080814155028.GB8256@mit.edu>
	<1218734985.9375.5.camel@paris.rdu.redhat.com>
	<20080814191726.GG22488@mit.edu>
	<20080814193408.GA10236@infradead.org>
	<20080814194111.GH22488@mit.edu>
	<alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
	<20080815020400.GG13048@mit.edu>
	<20080814204134.23c88f6c@infradead.org>
	<alpine.DEB.1.10.0808142149030.12859@asgard.lang.hm>
Date: Fri, 15 Aug 2008 07:12:56 +0200
In-Reply-To: <alpine.DEB.1.10.0808142149030.12859@asgard.lang.hm>
	(david@lang.hm's message of "Thu, 14 Aug 2008 22:05:15 -0700 (PDT)")
Message-ID: <87r68qx3mv.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

david@lang.hm writes:

> On Thu, 14 Aug 2008, Arjan van de Ven wrote:
>
>> On Thu, 14 Aug 2008 22:04:00 -0400
>> Theodore Tso <tytso@mit.edu> wrote:
>>
>>> On Thu, Aug 14, 2008 at 06:44:33PM -0700, david@lang.hm wrote:
>>>> could you do something like defining a namespace inside posix
>>>> attributes and then setting up a mechanism in the kernel to alert
>>>> if the attributes change (with the entire namespace getting cleared
>>>> if the file gets dirtied)?
>>>
>>> According to Eric Paris the clean/dirty state is only stored in
>>> memory.  We could use the extended attribute interface as a way of not
>>> defining a new system call, or some other interface, but I'm not sure
>>> it's such a great match given that the extended attributes interface
>>> are designed for persistent data.
>>>
>>> I agree that doesn't actually work very well for the tracker use case,
>>> where you the clean/dirty bit to be persistent (in case the tracker is
>>> disabled due to the fact you are running on battery, for example, and
>>> then you reboot).
>>>
>>
>> but we need a "give me all dirty files" solution, not a "is this file
>> dirty" solution.
>>
>> I do not want a virus scanner to constantly have to poll the whole fs
>> for dirty files ;-)
>
> I'm not sure.
>
> there are two situations (with the transition between them)
>
> 1. unscanned system, we want to do everything. (this happens
> immediatly after a new signature file is deployed)
>
> here you do just want to filter out the files that have been scanned
> from the list of everything, and you probably want to check at the
> time of scanning the file in case it was opened (and scanned) in the
> meantime.
>
> 2. mostly scanned system, we only want to scan files that have been
> dirtied.
>
> here you don't need to scan everything, you only need to scan in two cases
>
> 2a. the file was dirtied (you learn about it and add it to the queue
> of files to scan when you get around to it)
>
> 2b. an unscanned file is opened (the library detects that the file was
> not marked approved by all the current scanners, so it invokes the
> scanners on this file before completing the open, or copy for mmap, or
> whatever)

2b could also be used as a general lazy scanning mechanism, no?  If
there is a new signature or the file is dirty or unknown, scan it.
Always.

So this should all just be one case, no?

	Hannes
