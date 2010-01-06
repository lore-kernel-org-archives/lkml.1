Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685Ab0AFJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0AFJf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442Ab0AFJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:35:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:53512 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0AFJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OGFdfhJxNbqSTYDGOfq5cLkmAnFOBwcYMym08Q0U4HJ3eVymOE9NjDNGNgtpDHxH93
         X+t4mTXKd0gb+EcbsTz1ncMOJyNsVNRpOPQXcZIn7VZB8lCxgchRNYDrdBv09oQ7vu/k
         YiG+6B2nH94SB1CJ04UvjSmglzOc8k0rWaHHM=
Message-ID: <4B445957.3040301@gmail.com>
Date: Wed, 06 Jan 2010 10:35:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 15/16] COMPAT: add get/put_compat_rlimit
References: <4B040A03.2020508@gmail.com> <1258555922-2064-15-git-send-email-jslaby@novell.com> <200912310055.37707.arnd@arndb.de>
In-Reply-To: <200912310055.37707.arnd@arndb.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2009 12:55 AM, Arnd Bergmann wrote:
> On Wednesday 18 November 2009, Jiri Slaby wrote:
>>         set_fs(KERNEL_DS);
>> -       ret = sys_setrlimit(resource, (struct rlimit __user *) &r);
>> +       ret = sys_setrlimit(resource, (struct rlimit __force __user *)&r);
>>         set_fs(old_fs);
>>         return ret;
> 
> Since you are already rewriting the whole function here, it would be
> nice if you could just call do_setrlimit() with the kernel pointer
> instead of the set_fs() and __force tricks. For getrlimit, it may
> be easier to just open-code the whole function, and for your new
> functions, you could pass the pid into do_setrlimit instead of the
> task in order to reduce code duplication between compat_sys_setprlimit
> and sys_setprlimit.

Hmm, using pid_t wouldn't work well with pid namespaces. E.g. a call
from /proc code. But certainly some cleanups may be performed, at least
in {compat_,}sys_setrlimit case: pushing (resource >= RLIM_NLIMITS) test
down and calling do_setrlimit from compat_sys_setrlimit is
straightforward. Will look at the rest too.

> Yes, I realize my reply is late in this thread, but I assume your patch
> is still current since it hasn't made it into 2.6.33.

Yup, as you expressed, it's still not upstream, hence it can be tuned up
easily.

Thanks,
-- 
js
