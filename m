Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXK0PM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXK0PM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbXK0PMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:12:40 -0500
Received: from sacred.ru ([62.205.161.221]:48086 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451AbXK0PMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:12:39 -0500
Message-ID: <474C33DC.7090407@openvz.org>
Date: Tue, 27 Nov 2007 18:12:28 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/3] start the global /sbin/init with 0,0 special pids
References: <20071127135948.GA8370@tv-sign.ru> <m1bq9fk9rh.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bq9fk9rh.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 27 Nov 2007 18:12:28 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
>> As Eric pointed out, there is no problem with init starting with sid == pgid
>> == 0, and this was historical linux behavior changed in 2.6.18.
>>
>> Remove kernel_init()->__set_special_pids().
>>
>> This change and the previous change in daemonize() mean that /sbin/init does
>> not need the special "session != 1" hack in sys_setsid() any longer. We can't
>> remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, so
>> update the comment only.
> 
> I guess that works.  As long as we get there.  We just need one more patch
> in this series to fix the copy_process(CLONE_NEWPID).

I hope this will NOT be the fix that creates the namespace's 
init with the pid == 0 ;)

> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

