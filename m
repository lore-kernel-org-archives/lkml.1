Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXCMKZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXCMKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXCMKZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:25:59 -0400
Received: from smtp104.plus.mail.mud.yahoo.com ([68.142.206.237]:40573 "HELO
	smtp104.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752343AbXCMKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:25:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=EISV/mlJG8nv8GJdQWPtcBqc4oM0sVZT4PNQyQqPTi8++Vyr4KDhCPjZX6yRAokyRuMDMDvz82qbQxgP5mUsR0wm2P/wXONIY0kOMPxGMyTF6exZh8wtShqyLZkP59mfwwdW0XX9Kj3UZgZ1Nz+XG4MQITwwwKTvLHbeoBf9hLY=  ;
X-YMail-OSG: iXGZZCAVM1kZbjw39UOLE3p5ZfXY7.s75dSFXt7Ut1Bc46MQ4nLmpIFXeBQ4iP1K4cRnhY92LyYEWIlelgjI6t0BVn9DlNJKGXgF6eoanzdzpXI9mpXELQUYz6nladNqkIwBff03Co6P_e8-
Message-ID: <45F67C2D.7020303@yahoo.com.au>
Date: Tue, 13 Mar 2007 21:25:49 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at> <m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Herbert Poetzl <herbert@13thfloor.at> writes:
> 
> 
>>On Mon, Mar 12, 2007 at 09:50:08AM -0700, Dave Hansen wrote:
>>
>>>On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
>>>
>>>>For these you essentially need per-container page->_mapcount counter,
>>>>otherwise you can't detect whether rss group still has the page 
>>>>in question being mapped in its processes' address spaces or not. 
>>
>>>What do you mean by this?  You can always tell whether a process has a
>>>particular page mapped.  Could you explain the issue a bit more.  I'm
>>>not sure I get it.
>>
>>OpenVZ wants to account _shared_ pages in a guest
>>different than separate pages, so that the RSS
>>accounted values reflect the actual used RAM instead
>>of the sum of all processes RSS' pages, which for
>>sure is more relevant to the administrator, but IMHO
>>not so terribly important to justify memory consuming
>>structures and sacrifice performance to get it right
>>
>>YMMV, but maybe we can find a smart solution to the
>>issue too :)
> 
> 
> I will tell you what I want.
> 
> I want a shared page cache that has nothing to do with RSS limits.
> 
> I want an RSS limit that once I know I can run a deterministic
> application with a fixed set of inputs in I want to know it will
> always run.
> 
> First touch page ownership does not guarantee give me anything useful
> for knowing if I can run my application or not.  Because of page
> sharing my application might run inside the rss limit only because
> I got lucky and happened to share a lot of pages with another running
> application.  If the next I run and it isn't running my application
> will fail.  That is ridiculous.

Let's be practical here, what you're asking is basically impossible.

Unless by deterministic you mean that it never enters the a non
trivial syscall, in which case, you just want to know about maximum
RSS of the process, which we already account).

> I don't want sharing between vservers/VE/containers to affect how many
> pages I can have mapped into my processes at once.

You seem to want total isolation. You could use virtualization?

> Now sharing is sufficiently rare that I'm pretty certain that problems
> come up rarely.  So maybe these problems have not shown up in testing
> yet.  But until I see the proof that actually doing the accounting for
> sharing properly has intolerable overhead.  I want proper accounting
> not this hand waving that is only accurate on the third Tuesday of the
> month.

It is basically handwaving anyway. The only approach I've seen with
a sane (not perfect, but good) way of accounting memory use is this
one. If you care to define "proper", then we could discuss that.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
