Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbXLAT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbXLAT5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXLAT5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:57:14 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47187 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXLAT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:57:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Greg Kroah-Hartman <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca> <20071201111736.297dd99a@freepuppy.rosehill>
Date: Sat, 01 Dec 2007 12:54:52 -0700
In-Reply-To: <20071201111736.297dd99a@freepuppy.rosehill> (Stephen Hemminger's
	message of "Sat, 1 Dec 2007 11:17:36 -0800")
Message-ID: <m1bq9a5gxf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> writes:

> On Sat, 01 Dec 2007 08:10:17 -0500
> Mark Lord <lkml@rtr.ca> wrote:
>
>> > Now that we have network namespace support merged it is time to
>> > revisit the sysfs support so we can remove the dependency on !SYSFS.
>> ...
>> 
>> Now that the namespace updates are part of 2.6.24,
>> there is a major inconsistency in network EXPORT_SYMBOLs.
>> 
>> It used to be that an external network module could get away without
>> having to add a MODULE_LICENSE("GPL*") line to the source.
>> 
>> In support of that, common networking functions (still) use EXPORT_SYMBOL()
>> rather than the more restrictive EXPORT_SYMBOL_GPL().
>> 
>> Eg.  register_netdev(), sk_alloc(), __dev_get_by_name().
>> 
>> But now, none of those three are actually usable by default,
>> because they all require "init_net", which is EXPORT_SYMBOL_GPL().

Which alternative kernel does the above comment apply to?

> Then init_net needs to be not GPL limited. Sorry, we need to allow
> non GPL network drivers.

For the record network drivers should not be affected.  As a practical
measure that just gets unmaintainable and it is unnecessary.

There are specific exceptions where network drivers mess with the userspace
interfaces where I do have some impact.  However if you are messing
with our userspace interface especially with network namespaces in place
I don't see how it is possible for you to be anything other then a derivative
work, and something we need in tree to keep maintenance a manageable thing.

It should just be the core of the network stack that struct net has some
effect on.

> There is a fine line between keeping the
> binary seething masses from accessing random kernel functions, and allowing
> reasonable (but still non GPL) things like ndiswrapper to use network
> device interface.

Does ndiswrapper break?  If so what dubious and unsupportable thing is
it doing?

Eric
