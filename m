Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZBZKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZBZKKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZBZKK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:10:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:35531 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZBZKK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nd3jL8FD+8OriGg9CSWbvSObEpmuA/oM14dJQA6H2xUDBWpdt0ONA1ce4jwMCpRpM7
         BtI6X+3SWeGL9boG25sAeJyv4W3c/d9jUiFMKmESfCgrodo3nSeL5BO2mfA2YUakmKH/
         Uvewz8uA5c0VPnfhiInXgfLQZfzAthUc78uJ0=
MIME-Version: 1.0
In-Reply-To: <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	 <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A6501B.7040604@cn.fujitsu.com>
	 <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Feb 2009 15:40:23 +0530
Message-ID: <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: Bharata B Rao <bharata.rao@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 2:10 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 26 Feb 2009 16:35:33 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> ca is not checked before hierarchy support, and it's a side-effect.
>>
>> Before cpuacct is initialized, css == task->cgroups->subsys[cpuacct_subsys] == NULL,
>> but ca = task_ca(tsk) is not necessarily NULL, unless struct cgroup_subsys_state is the
>> first member of struct cpuacct.
>>
>> And the above code actually should be:
>>
>> do {
>>       ...
>> } while (ca->parent);
>>
> I'll send no more objections to this patch itself.
>
> But IMHO, this loop is tooo bad, I think. The hierarchy information should be gathered by
> read-side and the total code should be

How do you take care of accounting when a group gets deleted ?.
Wouldn't you loose some information due to deleted groups if you want
to accumulate hierarchical stats only during read ?

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
