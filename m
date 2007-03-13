Return-Path: <linux-kernel-owner+w=401wt.eu-S965658AbXCMJod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658AbXCMJod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXCMJod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:44:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35546 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965658AbXCMJoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:44:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <hansendc@us.ibm.com>
Cc: Kirill Korotaev <dev@sw.ru>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>
	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>
	<1173718208.11945.54.camel@localhost.localdomain>
	<45F588DE.3000309@sw.ru>
	<1173720796.11945.80.camel@localhost.localdomain>
Date: Tue, 13 Mar 2007 03:43:02 -0600
In-Reply-To: <1173720796.11945.80.camel@localhost.localdomain> (Dave Hansen's
	message of "Mon, 12 Mar 2007 10:33:16 -0700")
Message-ID: <m1zm6hscm1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <hansendc@us.ibm.com> writes:

> On Mon, 2007-03-12 at 20:07 +0300, Kirill Korotaev wrote:
>> > On Mon, 2007-03-12 at 19:23 +0300, Kirill Korotaev wrote:
>> >>For these you essentially need per-container page->_mapcount counter,
>> >>otherwise you can't detect whether rss group still has the page in question
> being mapped
>> >>in its processes' address spaces or not. 
>> > 
>> > What do you mean by this?  You can always tell whether a process has a
>> > particular page mapped.  Could you explain the issue a bit more.  I'm
>> > not sure I get it.
>> When we do charge/uncharge we have to answer on another question:
>> "whether *any* task from the *container* has this page mapped", not the
>> "whether *this* task has this page mapped".
>
> That's a bit more clear. ;)
>
> OK, just so I make sure I'm getting your argument here.  It would be too
> expensive to go looking through all of the rmap data for _any_ other
> task that might be sharing the charge (in the same container) with the
> current task that is doing the unmapping.  

Which is a questionable assumption.  Worse case we are talking a list
several thousand entries long, and generally if you are used by the same
container you will hit one of your processes long before you traverse
the whole list.

So at least the average case performance should be good.

It is only in the case when you a page is shared between multiple
containers when this matters.

Eric
