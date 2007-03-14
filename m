Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbXCNRIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbXCNRIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXCNRIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:08:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:21349 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXCNRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:08:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ngXX7WNXoNJb80+rs9rG/hlB3h70SKX2hg75JJT/upmhh5xduiFXZX7tO2AUYtB/oLCtW0cSu16X1ByRgNFK3W6Q8Vg3CJJoYnAnxEIKucyOQi2KtO7MmOmlHvBcl1mWnaR1W/tmJwzvv2TNTJIlwDYvlv2JglXvRlPwwVpFyVk=
Message-ID: <b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
Date: Wed, 14 Mar 2007 17:08:34 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible "struct pid" leak from tty_io.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	 <m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	 <m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	 <m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	 <b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	 <m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> How does this look?

It seems to fix the leak. I looked at the logs and proc_set_tty calls
put_pid twice for pid 245 (the unresolved leak) and get_pid for pid
296, which is later passed to put_pid via do_tty_hangup.

I still get the "error attempted to write to tty [0x00000000] = NULL"
when debugging is enabled in tty_io.c but it seems harmless.

> I don't have the setup to test this easily, but this bit makes seems to
> make sense.

And I don't have a fully tested kmemleak patch to post either :-).

Thanks.

-- 
Catalin
