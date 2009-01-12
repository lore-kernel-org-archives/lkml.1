Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZALLXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZALLXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZALLW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:22:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:54598 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZALLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lkpTP3FnNJyxwdgj+W7CUI0ENjz/EWnfatcPWJ0ZXhndy2Ibh4qU3i1tEMRBj5z36l
         +0lJiSmMLBXdTDAKZPFhpY6yh2vN/PPTiVIXMB3r/nL7Pb0V22Z5bG0FVTqSb5unNcOk
         EmVqQeSqH89oeFkYozAWV3ZrJ/N26Xw77Xm4k=
Message-ID: <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com>
Date: Mon, 12 Jan 2009 12:22:52 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Dieter Ries" <clip2@gmx.de>
Subject: Re: 2.6.29-rc1 does not boot
Cc: "Ingo Molnar" <mingo@elte.hu>, travis@sgi.com, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <496A3F62.8090902@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>
	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
	 <496A3F62.8090902@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/11 Dieter Ries <clip2@gmx.de>:
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
>>>>>

Simmilar issue, described:
http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/01701.html

[...]
####################################################################
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:09 2009 -0800
>
> cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>
> Impact: use new cpumask API to reduce stack usage
>
> Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr()
> with a work_on_cpu function for drv_read() and drv_write().
>
> Basically converts do_drv_{read,write} into "work_on_cpu" functions that
> are now called by drv_read and drv_write.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Revert this commit also solves problem on my laptoop.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
