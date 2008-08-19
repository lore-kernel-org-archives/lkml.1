Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYHSAEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYHSAEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYHSAEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:04:14 -0400
Received: from mail.lang.hm ([64.81.33.126]:55825 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYHSAEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:04:13 -0400
Date: Mon, 18 Aug 2008 17:03:52 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, peterz@infradead.org,
       hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
In-Reply-To: <20080818133038.GA4819@ucw.cz>
Message-ID: <alpine.DEB.1.10.0808181700570.15109@asgard.lang.hm>
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813103951.1e3e5827@infradead.org> <20080815160615.GD8860@ucw.cz> <alpine.DEB.1.10.0808180521010.12859@asgard.lang.hm> <20080818133038.GA4819@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Pavel Machek wrote:

> Hi!
>
>>> How does it work? Memory can still change after mmap;
>>> scanning at the
>>> mmap time is _NOT_ enough.
>>>
>>> You could do 'when app attempts to dirty memory,
>>> synchronously unmap
>>> it from all apps that have it mapped' and then do sync
>>> scan on
>>> pagefault time; but that sounds impractical.
>>
>> what is the threat you are trying to defend against?
>>
>> for some threats you are right, for others the scan at
>> mmap time is enough.
>
> I don't see any threats when check at mmap time is okay.
>
> As soon as file servers use mmap, this race can bite you even in very
> simple 'make sure Linux fileserver does not pass on windows malwar'
> threat model.

if you check the file at the time you mmap it and don't expect other 
programs to change the file under you while you are reading it, there's 
nothing to worry about.

shared mmap with one program being able to write to it is a expecially 
hard case of the general problem that if someone writes to a file as you 
are serving it, you don't know what goes out, it may be part of the old 
file and part of the new file. it's just easier to see this problem with 
mmap and harder to catch it.

David Lang
