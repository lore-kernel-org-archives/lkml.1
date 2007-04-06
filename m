Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXDFUBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXDFUBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932516AbXDFUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:01:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50108 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXDFUBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:01:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
	<20070406094413.GA673@tv-sign.ru>
	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
	<20070406154750.GA541@tv-sign.ru>
	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
	<20070406193621.GA96@tv-sign.ru> <20070406194756.GB96@tv-sign.ru>
Date: Fri, 06 Apr 2007 13:59:15 -0600
In-Reply-To: <20070406194756.GB96@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 6 Apr 2007 23:47:56 +0400")
Message-ID: <m1k5wp5l64.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/06, Oleg Nesterov wrote:
>>
>> --- t/kernel/exit.c~	2007-04-06 23:31:31.000000000 +0400
>> +++ t/kernel/exit.c	2007-04-06 23:31:57.000000000 +0400
>> @@ -275,10 +275,7 @@ static void reparent_to_init(void)
>>  	remove_parent(current);
>>  	current->parent = child_reaper(current);
>>  	current->real_parent = child_reaper(current);
>
> Just noticed. Eric, is it ok we are using child_reaper() here?
> This is for kernel threads only, shouldn't we always use
> init_pid_ns.child_reaper ? (yes, it is the same currently).

Yes.  It is a bug, and the description reparent_to_init is likewise
buggy.

I have recently realized that a number of the inital pid namespace
patches have stupid little bugs in them like this.  I am upset with
myself for failing to code review them closely before the went in.
Live and learn I guess.

So when I saw this I added this to my growing list of things I needed
to review before I could assume they were done correctly.

Feel free to fix it.  I'm still a couple days out from having enough
time before I can start working on pid related issues.

Eric
