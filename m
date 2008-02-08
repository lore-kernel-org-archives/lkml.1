Return-Path: <linux-kernel-owner+w=401wt.eu-S935190AbYBHRGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190AbYBHRGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbYBHQzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:55:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933745AbYBHQyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:54:20 -0500
Message-ID: <47AC8931.50704@redhat.com>
Date: Fri, 08 Feb 2008 10:54:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rth@redhat.com
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com>	<20080206143457.03e8741d.akpm@linux-foundation.org>	<47AA3EAA.9080204@redhat.com>	<20080206152239.a2352d6d.akpm@linux-foundation.org> <p73myqb2y09.fsf@bingen.suse.de>
In-Reply-To: <p73myqb2y09.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>>>   */
>>> -static int do_change_type(struct nameidata *nd, int flag)
>>> +static noinline int do_change_type(struct nameidata *nd, int flag)
>> What we could do here is defined a new noinline_because_of_stack_suckiness
>> and use that.  Reasons:
>>
>> - self-documenting, so we don't need to comment each site
>>
>> - can be made a no-op for suitable __GNUC__ values if gcc ever fixes this
> 
> In theory it should be already fixed; iirc Richard H. (cc'ed) added
> code for this somewhere in 4.x. Don't quite remember which x, likely 
> either 1 or 2.
> 
> e.g. if I do a quick test here on gcc 4.2 then it definitely
> reuses stack slots between inlines. As you can see only ~100 bytes
> are allocated, not ~200.

On gcc 4.1.2 and 4.3 (fedora flavors) I don't see it re-used in
do_mount, though... *shrug*

-Eric
