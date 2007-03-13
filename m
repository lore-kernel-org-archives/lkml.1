Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbXCMKAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbXCMKAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXCMKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:00:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53308 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXCMKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:00:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>
	<1173718208.11945.54.camel@localhost.localdomain>
	<20070312235452.GB11578@MAIL.13thfloor.at>
Date: Tue, 13 Mar 2007 03:58:05 -0600
In-Reply-To: <20070312235452.GB11578@MAIL.13thfloor.at> (Herbert Poetzl's
	message of "Tue, 13 Mar 2007 00:54:52 +0100")
Message-ID: <m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl <herbert@13thfloor.at> writes:

> On Mon, Mar 12, 2007 at 09:50:08AM -0700, Dave Hansen wrote:
>> On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
>> > 
>> > For these you essentially need per-container page->_mapcount counter,
>> > otherwise you can't detect whether rss group still has the page 
>> > in question being mapped in its processes' address spaces or not. 
>
>> What do you mean by this?  You can always tell whether a process has a
>> particular page mapped.  Could you explain the issue a bit more.  I'm
>> not sure I get it.
>
> OpenVZ wants to account _shared_ pages in a guest
> different than separate pages, so that the RSS
> accounted values reflect the actual used RAM instead
> of the sum of all processes RSS' pages, which for
> sure is more relevant to the administrator, but IMHO
> not so terribly important to justify memory consuming
> structures and sacrifice performance to get it right
>
> YMMV, but maybe we can find a smart solution to the
> issue too :)

I will tell you what I want.

I want a shared page cache that has nothing to do with RSS limits.

I want an RSS limit that once I know I can run a deterministic
application with a fixed set of inputs in I want to know it will
always run.

First touch page ownership does not guarantee give me anything useful
for knowing if I can run my application or not.  Because of page
sharing my application might run inside the rss limit only because
I got lucky and happened to share a lot of pages with another running
application.  If the next I run and it isn't running my application
will fail.  That is ridiculous.

I don't want sharing between vservers/VE/containers to affect how many
pages I can have mapped into my processes at once.

Now sharing is sufficiently rare that I'm pretty certain that problems
come up rarely.  So maybe these problems have not shown up in testing
yet.  But until I see the proof that actually doing the accounting for
sharing properly has intolerable overhead.  I want proper accounting
not this hand waving that is only accurate on the third Tuesday of the
month.

Ideally all of this will be followed by smarter rss based swapping.
There are some very cool things that can be done to eliminate machine
overload once you have the ability to track real rss values.  

Eric
