Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZBCL5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZBCL5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZBCL5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:57:33 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:50023 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mo5spdrJfEeWb9RpDW/C2vHPRIUiGC3j6alSumz97Jgm2ugxhgTpL4BVs62owFFt1M
         yds4P4tx6G3PNz7fkiwfVyLeSn7ctzNfu/Ro5d80hOoXWyxuDTCmFMEUUTrSQ5DHoJ9m
         pl5qU/Nd9Ch7pgbhyDOb+7yZlmjWEPDeX5McA=
MIME-Version: 1.0
In-Reply-To: <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
	 <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
Date: Tue, 3 Feb 2009 14:57:30 +0300
Message-ID: <a4423d670902030357k773e686dk5162b6c63a562e71@mail.gmail.com>
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120 
	seconds.
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> Alexander Beregalov <a.beregalov@gmail.com> wrote:
>> It seems it is blocked forever.
>
> Scanning the full memory may take a lot of time, depending on the
> amount of RAM and the number of objects allocated. It is not unlikely
> to take more than 120 seconds on some loaded systems. However, it
> should call schedule() periodically to let other tasks run. Is your
> system unresponsive during this?
No, it is responsible.
kmemleak proccess is not running all the time, but it is counted for
the loadavg value.
And it produceses lockdep message every 180 sec.
>
>> [ 1704.619898] INFO: task kmemleak:763 blocked for more than 120 seconds.
>> [ 1704.697951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 1704.791613] kmemleak      D 0000000000000001  6008   763      2
> [...]
>> [ 1706.246334] no locks held by kmemleak/763.
>
> It looks like the kmemleak thread is in the TASK_UNINTERUPTIBLE state.
> This happens when it calls schedule_timeout_uninterruptible() to sleep
> between scans. It probably took more than 120 to scan the memory and
> hence the report.
>
> It doesn't look like a problem, only that the watchdog thread checks
> for uninterruptible tasks. I can try to make it sleep with
> TASK_INTERRUPTIBLE to avoid the message.
>
> Thanks.
>
> --
> Catalin
>
