Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXE2C7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXE2C7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 22:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXE2C7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 22:59:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:15345 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXE2C73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 22:59:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lcmxUUocQMuf4MGW9+FrmXTSLCG38aD81Yrcw19fSPbD3Cu8yP4ibxiwHKqqIr9sh6GaG0E2V8kgHJ/RD7JkGY/QQY48aCXRrg/kMUuPj0t7VXcmdfYIz0+TIBwFYkGbHSzj8DeJ1fP4KtydCiKNYoKfX5AjrUQ/ove1zVS1xS4=
Message-ID: <787b0d920705281959l53e74d02g21a6fecd86d73219@mail.gmail.com>
Date: Mon, 28 May 2007 22:59:28 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, holt@sgi.com, ebiederm@xmission.com,
       oleg@tv-sign.ru, roland@redhat.com, davidel@xmailserver.org,
       mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt writes:
> On Mon, Apr 09, 2007 at 08:36:21AM -0600, Eric W. Biederman wrote:
>> Robin Holt <holt@sgi.com> writes:

>>> I would say this is more a benefit than a problem.  With a couple
>>> of these systems we are testing, the number of kernel threads is
>>> far greater than the number of user processes and having pstree
>>> not normally show them, but maybe have an option we add later to
>>> show them again would be beneficial.
>>
>> Sure.
>>
>> Robin how many kernel thread per cpu are you seeing?
>
> 10.

This has long been rotten. Mind fixing it for us? :-)

We have N types of thread on M CPUs. Pick something, N or M,
to be at the top level in /proc. The other goes below, in the
per-process task directories.

You then have either N or M things showing up in ps, not N*M.

Note that both ps and top can print the CPU number just fine.
Abusing the task name for this is just retarded. This suggests
that the top level should be the type of task, with the lower
level in /proc/*/task being per-CPU and not needing distinct
naming at all.
