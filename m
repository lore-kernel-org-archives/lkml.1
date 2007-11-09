Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXKIURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXKIURT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXKIURK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:17:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbXKIURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:17:09 -0500
Date: Fri, 9 Nov 2007 12:16:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Cc: andreas.herrmann3@amd.com, ak@suse.de, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix cpu-hotplug regression
Message-Id: <20071109121634.c7812697.akpm@linux-foundation.org>
In-Reply-To: <961aa3350711070615m4a165546k4fa888cb546846f6@mail.gmail.com>
References: <20071107011258.GA31607@alberich.amd.com>
	<200711070335.44416.ak@suse.de>
	<20071107131836.GB31607@alberich.amd.com>
	<961aa3350711070615m4a165546k4fa888cb546846f6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 23:15:38 +0900
"Akinobu Mita" <akinobu.mita@gmail.com> wrote:

> > [PATCH] x86: fix cpu hotplug regression (don't call mce_create_device on CPU_UP_PREPARE)
> >
> > Fix regression introduced with d435d862baca3e25e5eec236762a43251b1e7ffc
> > ("cpu hotplug: mce: fix cpu hotplug error handling").
> >
> > For CPUs not brought up during boot (using maxcpus and additional_cpus
> > parameters) we don't know whether mce is supported or not at "CPU_UP_PREPARE"-time.
> > Thus mce_cpu_callback should be called after the CPU is online.
> 
> Thank you for finding and fixing the problem.
> I added two fixes to your patch:
> 
> - Avoid mce_remove_device() for the CPU that is not correctly initialized
>   by mce_create_device() failure.
> 
> - make CPU_ONLINE callback always return NOTIFY_OK.
>   Because CPU_ONLINE callback return value is always ignored.
> 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> [akinobu.mita@gmail.com: make CPU_ONLINE callback always return NOTIFY_OK]
> [akinobu.mita@gmail.com: avoid mce_remove_device() for not initialized device]
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Andreas, could you please review and preferably runtime-test this new
version?

Assuming that all goes well could one of you please prepare a final patch
with a complete changelog?

Thanks.
