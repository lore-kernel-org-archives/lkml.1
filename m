Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYLESKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYLESKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYLESKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:10:30 -0500
Received: from smtp-out.google.com ([216.239.45.13]:5674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYLESKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:10:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=W+AXMb4CYBjJ3OZkGj28CS3kyR11OyfTAqxpsHUxzsoc1wY+b8TcI8vrf/862RLAS
	RcjX3F0X2diz5uUddYF4A==
MIME-Version: 1.0
In-Reply-To: <4938DE1C.6070608@cn.fujitsu.com>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	 <49376BE3.1040909@cn.fujitsu.com>
	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
	 <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>
	 <4938DE1C.6070608@cn.fujitsu.com>
Date: Fri, 5 Dec 2008 10:10:25 -0800
Message-ID: <b040c32a0812051010m11e9d376qcd77a3a71a4f42b9@mail.gmail.com>
Subject: Re: [patch] export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 11:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +             seq_printf(m, "%llu ", percpu);
>
> Should be:
> +               seq_printf(m, "%llu ", (unsigned long long)percpu);
>
> Otherwsise:
> kernel/sched.c: In function 'cpuacct_percpu_seq_read':
> kernel/sched.c:9359: warning: format '%llu' expects type 'long long unsigned int',
> but argument 3 has type 'u64'

I'm curious what compiler and CPU arch target are you using that cause
compiler to spit out this warning message?  On x86_64 u64 is unsigned
long long and gcc v4.2.4 doesn't give such warning.

- Ken
