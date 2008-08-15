Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYHOBot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYHOBot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYHOBok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:44:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:42177 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYHOBok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:44:40 -0400
Date: Thu, 14 Aug 2008 18:44:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
In-Reply-To: <20080814194111.GH22488@mit.edu>
Message-ID: <alpine.DEB.1.10.0808141837430.13400@asgard.lang.hm>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com>
 <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Theodore Tso wrote:

> On Thu, Aug 14, 2008 at 03:34:08PM -0400, Christoph Hellwig wrote:
>>
>> It's not used at all on regular files except for ext4 with a non-default,
>> undocumented mount option.  XFS will grow it soon in a similar way as ext4,
>> except that it will be documented or I might have even figured out by
>> then how to just enabled it from nfsd.
>
> We do need a standardized way of enabling it (since it does cost you
> something in performance, so not everyone will want it on), and a
> standardized way of reading i_version out to userspace.  Maybe a mount
> option is the right way to do it, maybe not.
>
> We may want to take this to the linux-fs list and try to get
> agreements on these points; the main reason why it's not enabled by
> default in ext4 is because the NFSv4 advanced caching code is in
> common use (is it even in mainline)?

could you do something like defining a namespace inside posix attributes 
and then setting up a mechanism in the kernel to alert if the attributes 
change (with the entire namespace getting cleared if the file gets 
dirtied)?

this would have the advantage of storing the clean/dirty state in a known 
location on the filesystem (you would need to enable posix attributes, but 
that should be an acceptable limit), and would allow multiple scanners 
(virii, indexing, etc) to do their own thing at their own schedule when 
things get dirtied.

the userspace library calls that open the files would be able to take care 
of the issue of deciding which of the configured scanners on a system 
should be called for each attribute that's not set on a file.

This would seem to require minimal kernel support

1. reserve a attribute namespace

2. clear that namespace if the file is dirtied

3. provide a notification mechanism for programs to subscribe to that 
lists all files where the namespace was not already empty when the file 
was dirtied.

everything else can be userspace.

David Lang
