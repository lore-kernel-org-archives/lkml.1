Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYHVTKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYHVTKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYHVTKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:10:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:63820 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbYHVTKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NEhY/V2o8wmPUXa8NI1+ho3je1X6sYUfU96bCWy2mnHs3K2XBuVJztOLrLECUXztWB
         FcvaJXDmCt059Ha2bHRxMIQLUrXSfAsVDtrqNiZ7cUdPDRVsflvTpecTQwrT33T/saZz
         EAHwP2sFT4QQPk3Gufe5HSsMU0g9civgGqTT4=
Message-ID: <86802c440808221210x40057476p5566d0dc82032608@mail.gmail.com>
Date: Fri, 22 Aug 2008 12:10:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jan Beulich" <jbeulich@novell.com>
In-Reply-To: <20080822190724.GB14103@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD82D5.76E4.0078.0@novell.com>
	 <1219429418-29023-2-git-send-email-robert.richter@amd.com>
	 <86802c440808221156h7ef48973hb5db8cf2b01ac27b@mail.gmail.com>
	 <20080822190724.GB14103@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 12:07 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 22.08.08 11:56:08, Yinghai Lu wrote:
>
> [...]
>
>> > +static int __init pci_io_ecs_init(void)
>> > +{
>> > +       int cpu;
>> > +
>> >        /* assume all cpus from fam10h have IO ECS */
>> >         if (boot_cpu_data.x86 < 0x10)
>> >                return 0;
>> > -       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1);
>> > +
>> > +       register_cpu_notifier(&amd_cpu_notifier);
>> > +       for_each_online_cpu(cpu)
>> > +               amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
>> > +                              (void *)(long)cpu);
>>
>> wonder if those two lines should be reversed.
>
> Do you mean setting PCI_HAS_IO_ECS before for_each_online_cpu(...)?
> PCI_HAS_IO_ECS will be used only in pci_direct_init(). PCI is
> initialized in a later init stage, so it doesn't matter. My intention
> was to set the bit after the setup of all online cpus is finished.


==>
+       for_each_online_cpu(cpu)
+               amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
+                              (void *)(long)cpu);
+       register_cpu_notifier(&amd_cpu_notifier);

YH
