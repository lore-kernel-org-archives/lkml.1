Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZCDKf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZCDKf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZCDKfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:35:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:40594 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCDKfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lpS7ZnJ4E5iWjrYlEnuiSKB51rIF3mGSzvxymS55nnreP4d6Bdt/9Weih8aULcPPoH
         KDRyvfyaWdhpAdM305vaUk6gP/7Uo1ji7HggL7RvaEr6wBuALmztVPH0UNWDEqhyYvxa
         TK87a8WCKbog48lEoUCB9mYKvZTf6sypGr0p8=
MIME-Version: 1.0
In-Reply-To: <20090304174635.43d0f554.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com> <1236066689.18955.27.camel@twins>
	 <d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
	 <1236073236.18955.46.camel@twins>
	 <2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
	 <1236081288.5330.4105.camel@laptop>
	 <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0903032354r38d74c48p217d338cba7159e8@mail.gmail.com>
	 <20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090304174635.43d0f554.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 4 Mar 2009 16:05:14 +0530
Message-ID: <344eb09a0903040235gbed8f07vdfd94a20499fb4e0@mail.gmail.com>
Subject: Re: [PATCH] remove rq->lock from cpuacct cgroup v2
From: Bharata B Rao <bharata.rao@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, kenchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 2:16 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 4 Mar 2009 17:20:05 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Wed, 4 Mar 2009 13:24:43 +0530
>> Bharata B Rao <bharata.rao@gmail.com> wrote:
>> At first, generic per-cpu counter sounds interesting but to be honest,
>> some special handling is used for cpuacct based on its characteristic.
>>
>>   - Writer works under non-preemptable context.
>>   - There is only one writer.
>>
> If utime/stime updates works on above context, using the same code will be good.

IIUC, utime/stime updates also work under the above conditions.

>
> I don't use any cpuacct structure specific in routines...
> If you want me to rewrite it, I'll do. please request what you want.

After looking deep into your patch, I think I could use the same seq
counter introduced by you to update stime/utime also.
I guess I could use most part of your code except there is a slight
difference wrt preemption disabled assumption in the write path.
cpusuage updates happen under rq->lock but stime/utime updates don't.
So I probably can't use cpuacct_start/end_counter_update as is.

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
