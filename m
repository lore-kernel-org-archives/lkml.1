Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZECXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZECXVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZECXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:21:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:3777 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZECXVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rY7XiykMBFTxg05zseBgFQKi9TqzRvxHeN7m2WowUK2djm2P/1AKODZtK9wTKAGCZU
         sCmNmVcqIrcdpvhrh/ZzXCDPXZqmfoC4HGwSvkqe0AsmGToN1h5yN6BHi2leRWnjfB+2
         OhFzBq8mzsjaQ5ItWIAoNmM3N50490xULGfWE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904281507240.30946@chino.kir.corp.google.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	 <Fg2zLW93smL.A.oGE.Zd48JB@chimera> <49F4DF40.50302@intel.com>
	 <alpine.DEB.2.00.0904281507240.30946@chino.kir.corp.google.com>
Date: Sun, 3 May 2009 16:21:37 -0700
X-Google-Sender-Auth: a7673cbfdeadcfc2
Message-ID: <e9c3a7c20905031621s2a1dc934x11ca1c50859ca75e@mail.gmail.com>
Subject: Re: [Bug #13116] Can't boot with nosmp
From: Dan Williams <dan.j.williams@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 3:14 PM, David Rientjes <rientjes@google.com> wrote:
> On Sun, 26 Apr 2009, Dan Williams wrote:
>
>> Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.29.  Please verify if it still should be listed and let me know
>> > (either way).
>>
>> This is still unresolved.
>>
>> Stephen, please send your config.
>>
>
> Given the stack for the initial report, why would a config other than
> enabling CONFIG_DMA_ENGINE help if there's no ifdefs involved?

...because I have been unable to reproduce it and wanted to start
eliminating differences in our respective setups.  I have booted an
oversubscribed (8-virtual / 2 physical cpus) kvm instance with 2.6.29
and have not seen this reproduce.

> This is happening in the for_each_possible_cpu() loop within
> dma_channel_rebalance(), which makes sense since the machine boots fine
> normally but not with `nosmp'.
>
> channel_table[] is not being initialized per-cpu for non-online cpus?

I'm grasping, but could this possibly be a kvm quirk whereby
cpu_possible_map gets out of sync with cpu_online_map in the 'nosmp'
case?

--
Dan
