Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXKGCjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXKGCjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXKGCj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:39:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:40074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXKGCj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:39:27 -0500
From: Andi Kleen <ak@suse.de>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: fix cpu-hotplug regression
Date: Wed, 7 Nov 2007 03:35:43 +0100
User-Agent: KMail/1.9.1
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Akinobu Mita" <akinobu.mita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20071107011258.GA31607@alberich.amd.com>
In-Reply-To: <20071107011258.GA31607@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711070335.44416.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 02:12, Andreas Herrmann wrote:

> In cases where not all CPUs are brought up during
> boot (e.g. using maxcpus and additional_cpus parameters)
> mce_cpu_callback now returns NOTFIY_BAD because
> for such CPUs cpu_data is not completely filled when
> the notifier is called. Thus mce_create_device fails right
> at its beginning:
>
>         if (!mce_available(&cpu_data[cpu]))
>                 return -EIO;
>
> As a quick fix I suggest to check boot_cpu_data for MCE.

I guess it would be better to just move the device creation
to after the CPU has booted. AKA call mce_create_dev() on CPU_ONLINE
instead.

-Andi
