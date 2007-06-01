Return-Path: <linux-kernel-owner+w=401wt.eu-S1763641AbXFAV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763641AbXFAV5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761568AbXFAV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:57:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbXFAV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:57:21 -0400
Message-ID: <46609636.4050208@zytor.com>
Date: Fri, 01 Jun 2007 14:57:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com> <466093E3.4010701@goop.org>
In-Reply-To: <466093E3.4010701@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>>> Do we care particularly? If 8 bytes is enough for the subarch, do we
>>> care whether its a pointer or literal? After all, this is just a private
>>> channel between the bootloader and some subarch-specific piece of code
>>> in the kernel.
>>>
>>>     
>> I see two options: either we make it a pointer *and a length* so that a
>> loader can reshuffle it at will (that also implies no absolute pointers
>> within the data), or it's an opaque cookie anyway.
> 
> No, it has to be completely opaque.  It might be a pointer to some
> special shared memory or something, and not movable.
> 

Well, if we define is as a movable object then it has to be treated as
such.  It's a protocol definition issue.  If we define it opaque, though
-- of for that matter, if we don't -- we should define what memory it
can live in, though.  Right now, the only "available" memory we have is
end of setup to 0xa0000; the command line is defined to be allocated
from this memory.

	-hpa
