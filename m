Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZCCI05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZCCI05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCCI0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:26:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZCCI0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:26:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yj2o6VS9wCLDbeOMEPGy6y2t3gFJL1apfiLwDykqq2qAt/2xLWK5DpMWQcsY4DgyO
	eS/lzSsr9iQorcY9dVRxA==
MIME-Version: 1.0
In-Reply-To: <6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
	 <49ACA13B.5050106@cn.fujitsu.com>
	 <6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>
Date: Tue, 3 Mar 2009 00:26:42 -0800
Message-ID: <6599ad830903030026w2081a72dhf3cac90346b1d806@mail.gmail.com>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 10:01 PM, Paul Menage <menage@google.com> wrote:
> On Mon, Mar 2, 2009 at 7:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> +static int generate_sched_domains(struct cpumask **domains,
>>> +                     struct sched_domain_attr **attributes)
>>> +{
>>
>> Except here should "return 0;", otherwise emit a compile warining.
>>
>
> Good catch - the weird thing is that (in my UML build) it doesn't
> actually generate that warning. Mysterious.
>
> I'll resend with the extra return.

After looking at the sched domains code it's not clear to me that
returning 0 is necessarily the right thing to do -
partition_sched_domains() says that 0 is a special case used for
destroying existing domains? Would returning 1 and setting up a single
dummy domain be better?

Given that this return code only matters when CONFIG_HOTPLUG_CPU &&
!CONFIG_SMP it's unlikely to ever be used, but I guess it's better to
get it right.

Paul
