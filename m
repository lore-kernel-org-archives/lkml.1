Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbZGZDeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbZGZDeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 23:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZGZDeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 23:34:04 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:34518 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZGZDeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 23:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qCbA4uCmdMt4UC4E0c1Dof5/WcTCMDy4+VUrUHE2TMlyEwkko0+nIs4JTslXwaIp2V
         3Hpbn2bPyF8CeZ3CnyujlzBQ0IxNHbB3j0zYdsUzas+7hPAhUVzc1a8dGCVkYEncY51h
         R7g+8HsBvcNflP+zosHRbsd4/V1v2SPaWShtg=
MIME-Version: 1.0
In-Reply-To: <458a17f90907240745m15c3d7ep893a01a035bf0146@mail.gmail.com>
References: <458a17f90907240745m15c3d7ep893a01a035bf0146@mail.gmail.com>
Date: Sun, 26 Jul 2009 11:34:02 +0800
Message-ID: <2f495dc80907252034i4bdd812cx2267d65af7d993d8@mail.gmail.com>
Subject: Re: inaccurate cpu idle time from top command
From: Fred Fan <fanyefeng@gmail.com>
To: cocala <syy.wxd@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, rick.jones2@hp.com,
       gallatin@myri.com, akpm@linux-foundation.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com, brice@myri.com, paulus@samba.org,
       benh@kernel.crashing.org, mingo@elte.hu, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi cocala:
    I have met same issue. And we found the total utilization
count(added by idle's utilization) is not 100% in detail processes
information fields.
   best Regards
Fred

2009/7/24 cocala <syy.wxd@gmail.com>:
> I saw one commit "3209ada8285a9fa6ab8f7a731d54031ec884c745 - sched: account
> system time properly"
> This commit is to take into account timer IRQ interrupting the idle task
> servicing a hard or soft irq.
>
> If a softirq is started in a tick, all the time in the tick will be counted
> as soft irq time even most time in the tick is idle.
> In our use case, one jiffy is 10ms and the 1G net driver will generate many
> software irq, so the "top" command will show high softare irq time and cpu
> idle time approaches to zero.
> If I change the jiffy to 1ms, the "top" command shows much higher cpu idle
> time. I think this algorithm is also not fair for some cases.
>
> Is there any better way to count the softare irq time?
>
> Thanks
> cocala
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>
