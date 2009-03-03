Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZCCGlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZCCGlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCCGlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:41:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZCCGlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:41:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OFlaokAkT/0a0sdSFoZK7lU0U3Um8JQBt7Llyc5fev10qm1IpU9Z2EBZ1xT1QbpEZ
	ot1VqDQW16efOwfjDGiDQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>
References: <20090303013432.11211.18662.stgit@menage.corp.google.com>
	 <49ACA13B.5050106@cn.fujitsu.com>
	 <6599ad830903022201s4d2296c7u225e84a77f9f7167@mail.gmail.com>
Date: Mon, 2 Mar 2009 22:41:42 -0800
Message-ID: <6599ad830903022241o222ed5acjd4d91625ea79f629@mail.gmail.com>
Subject: Re: [PATCH] Allow cpusets to be configured/built on non-SMP systems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
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

Hmm, my guess is that since UML doesn't have hotplug either, the only
reference to generate_sched_domains doesn't actually invoke it, so gcc
doesn't even bother compiling it.

Paul
