Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbXHFQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbXHFQOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXHFQOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:14:40 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:18426 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752432AbXHFQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:14:39 -0400
Message-ID: <46B748DE.1060108@interia.pl>
Date: Mon, 06 Aug 2007 18:14:22 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl> <200708052142.14630.jimis@gmx.net>
In-Reply-To: <200708052142.14630.jimis@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 5e5c4acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello and thanks for your reply. 
Hello again, 
> The cron job that is running every 10 min on my system is mpop (a 
> fetchmail-like program) and another running every 5 min is mrtg. Both 
> normally finish within 1-2 seconds. 
> 
> The fact that these simple cron jobs don't finish ever is certainly because of 
> the high system CPU load. If you see the two_discs_bad.txt which I attached 
> on my original message, you'll see that *vmlinux*, and specifically the 
> *scheduler*, take up most time. 
> 
> And the fact that this happens only when running two i/o processes but when 
> running only one everything is absolutely snappy (not at all slow, see 
> one_disc.txt), makes me sure that this is a kernel bug. I'd be happy to help 
> but I need some guidance to pinpoint the problem. 
In Your oprofile output I find "acpi_pm_read" particulary interesting. Unlike 
other VIA chipsets, which I know, Your doesn't use VLink to connect northbridge 
to southbridge. Instead PCI bus connects these two. As You probably know 
maximal PCI throughtput is 133MiB/s. In theory. In practice probably less.
ACPI registers are located on southbridge. This probably means that processor 
needs access to PCI bus in order to read ACPI timer register.
Now some math. 20GiB disk probably can send data at 20MiB/s rate. 200GiB 
disk probably about 40MiB/s. So 20+2*40=100MiB/s. I think that this could 
explain why simple inl() call takes so much time and why Your system isn't 
very responsive.
> Thanks, 
> Dimitris
Let me know if You find my theory amazing or amusing.
Rafał


----------------------------------------------------------------------
Kobiety klamia o wiele skuteczniej niz mezczyzni.
Sprawdz, jak sie na nich poznac

>>>http://link.interia.pl/f1b16

