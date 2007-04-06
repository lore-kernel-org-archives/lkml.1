Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXDFTQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXDFTQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXDFTQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:16:01 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49521 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXDFTQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:16:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
	<20070406094413.GA673@tv-sign.ru>
	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
	<20070406154750.GA541@tv-sign.ru>
	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
	<m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>
	<46169A34.3030808@zytor.com>
Date: Fri, 06 Apr 2007 13:15:01 -0600
In-Reply-To: <46169A34.3030808@zytor.com> (H. Peter Anvin's message of "Fri,
	06 Apr 2007 12:06:28 -0700")
Message-ID: <m1slbd5n7u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> Oleg is coming from a different case where it was found that exiting kernel
>> threads were causing problems for nash when nash was run as init in an
>> initramfs.  While I think that case is likely a user space bug because
>> nash should check the pid from waidpid before assuming the process it
>> was waiting for returned.
>>
>
> Are you saying waitpid() (wait4) *with a pid specified* can return another pid?
> That definitely sounds like a bug.

No.

For the full context look back a couple of messages.

I'm guessing the issue is nash just calls wait and doesn't check the
returned pid value, assuming it is the only child it forked returning.
Which is valid except when you are running as pid == 1.

Eric
