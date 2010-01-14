Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113Ab0ANLAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0ANLAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938Ab0ANLAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:00:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0ANLAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:00:08 -0500
Message-ID: <4B4EF92C.5070402@redhat.com>
Date: Thu, 14 Jan 2010 18:59:56 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Frans Pop <elendil@planet.nl>
Subject: Re: [RFC PATCH] accouting: account if a task was killed by OOM killer
References: <1263192034-10898-1-git-send-email-dfeng@redhat.com> <20100113145403.e44a5490.akpm@linux-foundation.org>
In-Reply-To: <20100113145403.e44a5490.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 06:54 AM, Andrew Morton wrote:
> On Mon, 11 Jan 2010 14:40:34 +0800
> Xiaotian Feng<dfeng@redhat.com>  wrote:
>
>> This patch introduces a new accounting flag which is set when a task
>> was killed by OOM killer. taskstats can tell users when a job has been
>> killed by the oomkiller.
>>
>
> Why is this useful?  I'd be looking for a description of some
> operational scenario where this feature is valuable to an operator?
>

users of taskstats need to know if a job is killed by OOM killer, then 
perform some automation jobs or notifications.
But current taskstats logs AXSIG if a job is killed by signal, so users 
will be confused by SIGKILL, SIGTERM or OOM killer.

> The description is incomplete.  The patch also alters the contents of
> the BSD accounting records.  That's a change to an ancient interface
> and needs a bit of exposure and thought.  Is it good to put such a
> highly linux-specific and somewhat linux-version-specific field into
> such a venerable userspace interface?
>
> If we _do_ decide to change the BSD accounting records in this manner
> then presumably a manpage will need to be updated.  A cc to
> linux-api@vger.kernel.org would be appropriate.

The BSD accounting part is not necessary, I just made it same as 
taskstats, we can drop BSD accounting part.

>
> But I'm not very convinced about this whole idea at present, personally.
>
>>   include/linux/acct.h                          |    1 +
>>   include/linux/taskstats.h                     |    2 +-
>>   kernel/acct.c                                 |    2 ++
>>   kernel/tsacct.c                               |    2 ++
>
> I'm a bit surprised that getdelays.c doesn't print ac_flag.
>
>
>

