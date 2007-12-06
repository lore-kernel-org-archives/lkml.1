Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXLFRZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXLFRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXLFRZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:25:22 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54742 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXLFRZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:25:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, sukadev@us.ibm.com
Subject: Re: [PATCH] pid: sys_wait... fixes
References: <m17ijsv7iu.fsf@ebiederm.dsl.xmission.com>
	<20071206170145.GA10674@tv-sign.ru>
Date: Thu, 06 Dec 2007 10:21:39 -0700
In-Reply-To: <20071206170145.GA10674@tv-sign.ru> (Oleg Nesterov's message of
	"Thu, 6 Dec 2007 20:01:45 +0300")
Message-ID: <m1y7c7spr0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 12/05, Eric W. Biederman wrote:
>> 
>> This modifies do_wait and eligible_child to take a pair of
>> enum pid_type and struct pid *pid to precisely specify what
>> set of processes are eligible to be waited for,  instead of the
>> raw pid_t value from sys_wait4.
>
> Personally, I like this patch very much. Not only it fixes the bug,
> in my opinion it also makes the code more clean.
>
> However at first glance it has a minor fixable problem,
>
>> +	if (type < PIDTYPE_MAX) {
>> +		if (p->pids[type].pid != pid)
>>  			return 0;
>>  	}
>
> If type != PIDTYPE_PID we can't trust p->pids[type].pid unless p is a
> group leader. This .pid could be just a "random value".

Ugh.  You are correct.  Thanks for the review.
That is one annoying special case.

Eric
