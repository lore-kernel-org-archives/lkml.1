Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZINJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZINJ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZINJ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:28:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:2367 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZINJ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xkVxxb7ojjkTFYnWC+8jVkNvIC+YSUmDlj2TmIV2+Zi0KAwnCNFy3JY6fnDlcfVPZC
         E4jVZXgGP3h8x9qRvk4Q+Pms/hWeuexGENe2a2p5C6eEqu26U15LyVUKt4dC4X3mlZ4L
         rgtJOe3wiaRfP4aUnOMH8c2WIOk4UgCchylpI=
Message-ID: <4AAE0CC2.5010502@gmail.com>
Date: Mon, 14 Sep 2009 11:28:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.6 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: clocksource: !keventd_up() && schedule_work() == oops
References: <4AA760B6.6070601@gmail.com>
In-Reply-To: <4AA760B6.6070601@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 10:00 AM, Jiri Slaby wrote:
> Hi,
> 
> I started to see oopses on boot in qemu machine because keventd is
> created in kernel_init/do_basic_setup, but schedule_work is done earlier
> in kernel_init/smp_init[1] when the tsc is unstable during this early phase.
> 
> It looks like "clocksource: Resolve cpu hotplug dead lock with TSC
> unstable" is the culprit.
> 
> Creating its own either singlethread or "multithread" workqueue won't
> work either (we do not have singlethread_cpu and cpu_populated_map).
> Checking !keventd_up() in the clocksource code looks to me like a hack.
> Any ideas, please?

Still present in mmotm 2009-09-14-01-57.

> [1]
> kernel_init/smp_init/cpu_up/native_cpu_up/check_tsc_sync_source/mark_tsc_unstable/clocksource_mark_unstable/__clocksource_unstable

