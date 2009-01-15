Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZAOUcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZAOUcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZAOUBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:37 -0500
Received: from relay3.sgi.com ([192.48.171.31]:32990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762624AbZAOUBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:13 -0500
Message-ID: <496F9604.8020101@sgi.com>
Date: Thu, 15 Jan 2009 12:01:08 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Dieter Ries <clip2@gmx.de>, "Maciej Rutecki" <maciej.rutecki@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de>
In-Reply-To: <496A3F62.8090902@gmx.de>
Content-Type: multipart/mixed;
 boundary="------------030802040507010307000100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030802040507010307000100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

* Dieter Ries wrote:
> Hi,
> 
> Ingo Molnar schrieb:
>>>> * Dieter Ries <clip2@gmx.de> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
>>>>> When I try to boot it, that kind of works until init should start. Then
>>>>> nothing happens. I tried with init=/bin/bash, which sometimes works, and
>>>>> sometimes gets me a bash without the prompt flashing.
...

* Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> Revert this commit also solves problem on my laptoop.

Hi Dieter and Maciej,

Can you try the attached patches on your system?  It boots on my system fine
now, but wasn't there a problem with resume as well?  (My test systems are
remote so suspending/resuming over the network is iffy.)

The patches apply to the latest tip/cpus4096 branch:

	http://people.redhat.com/mingo/tip.git/README

(They may apply to linux-next as well, I'm not sure.)

Thanks!
Mike

========================
Subject: cpumask: don't try to get_online_cpus() in work_on_cpu.

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: remove potential circular lock dependency with cpu hotplug lock

This has caused more problems than it solved, with a pile of cpu
hotplug locking issues.

Followup patches will get_online_cpus() in callers that need it, but
if they don't do it they're no worse than before when they were using
set_cpus_allowed without locking.
========================
Subject: work_on_cpu: Use our own workqueue.

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: remove potential circular lock dependency with generic kevent workqueue

Annoyingly, some places we want to use work_on_cpu are already in
workqueues.  As per Ingo's suggestion, we create a different workqueue
for work_on_cpu.

========================
Subject: cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Impact: use new work_on_cpu function to reduce stack usage

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
a work_on_cpu function for drv_read() and drv_write().

Basically converts do_drv_{read,write} into "work_on_cpu" functions that
are now called by drv_read and drv_write.
========================

--------------030802040507010307000100
Content-Type: application/x-bzip;
 name="fix-work_on_cpu-in-acpi-cpufreq.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="fix-work_on_cpu-in-acpi-cpufreq.tar.bz2"

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
--------------030802040507010307000100--
