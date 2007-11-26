Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXKZVnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXKZVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXKZVnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:43:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57338 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXKZVni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:43:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] teach set_special_pids() to use struct pid
References: <20071126142555.GA16528@tv-sign.ru>
	<m18x4kon6i.fsf@ebiederm.dsl.xmission.com>
	<20071126201757.GB84@tv-sign.ru>
Date: Mon, 26 Nov 2007 14:42:33 -0700
In-Reply-To: <20071126201757.GB84@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 26 Nov 2007 23:17:57 +0300")
Message-ID: <m1myt0n0om.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 11/26, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > -	set_special_pids(1, 1);
>> > +	if (current->nsproxy != &init_nsproxy) {
>> > +		get_nsproxy(&init_nsproxy);
>> > +		switch_task_namespaces(current, &init_nsproxy);
>> > +	}
>> 
>> Is there a reason for moving this hunk of code?
>> 
>> I don't see one as set_special_pids does everything with either
>> struct pid or global pid values.  And attach_pid and detach_pid
>> don't care.
>
> No particular reason, except "keep related code together".
>
> There was another minor reason. Without the next patch we are doing find_pid(1).
> This is correct, we scan the global namespace, but still it looks a bit tidier
> to switch namespace first, so we could use find_vpid() in unlikely case we need
> it.

True.  I just pointed it out because it seemed an unnecessary chunk.
Regardless it is harmless either way.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
