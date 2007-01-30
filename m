Return-Path: <linux-kernel-owner+w=401wt.eu-S965580AbXA3PJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965580AbXA3PJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965592AbXA3PJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:09:07 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53885 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965580AbXA3PJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:09:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@osdl.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bug reading /proc/sys/kernel/*: only first byte read.
References: <4538C47B.9060808@tls.msk.ru>
	<20070130022457.d0159eba.akpm@osdl.org>
	<20070130132559.GA315@tv-sign.ru> <20070130140015.GA123@tv-sign.ru>
Date: Tue, 30 Jan 2007 08:07:51 -0700
In-Reply-To: <20070130140015.GA123@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 30 Jan 2007 17:00:15 +0300")
Message-ID: <m1y7nkh7so.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 01/30, Oleg Nesterov wrote:
>>
>> On 01/30, Andrew Morton wrote:
>> >
>> > +			if (len + pos < maxlen) {
>>                         ^^^^^^^^^^^^^^^^^^^^^^^
>> Shouldn't this be
>> 			if (len < *lenp)
>> 
>> ?
>
> On the other hand. If we may assume that original code was correct,
> we can make a simpler patch?

I think there is an issue worth fixing her.

However as far as I can tell the code has this limitation
deliberately for simplicity.

Getting the string side of this fixed even by itself is
worthwhile, although it might be worth teach people
about sys_uname and /bin/uname.  It seems is the biggest thing
people look at /proc/sys/ for...

For the non-string data the only way we can do this is to
generate it into a temporary buffer and the read out the
part of the buffer the user is requesting.  Isn't there
something in seq_file that will do this?

On the other side I'm fairly certain we can't support
short writes to magic sysctl files on the write side of things.

I do have to say I like Oleg short version of this patch.

Eric
