Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXEEFkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXEEFkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 01:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXEEFkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 01:40:41 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:47935 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754653AbXEEFkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 01:40:40 -0400
Message-ID: <463C18C4.7030304@interia.pl>
Date: Sat, 05 May 2007 07:40:20 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Johnson <dj@david-web.co.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>	<200705042320.41278.dj@david-web.co.uk> <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: cd86cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

Can You send output of x86info program and output of 
lspci command? Longhaul wasn't working for You since 2.6.18 right?
I'm going to work now, but I will be available after 14:00 UTC.

If You have problem with longhaul+powersave there may be one thing 
related. When I started to change Longhaul it was causing lockups 
on Epia 800. I added transition protection. Helped, but not for 
long. After one or two hours machine locked up anyway. I found 
datasheet in Google and changed "disable BMDMA bit on PCI device" to 
northbridge support. Problem fixed. Somehow CLE133 chipset didn't 
like touching "BMDMA master" bits.
Second: I didn't get answer from VIA why they are blocking ACPI C3 on CPU's 
faster then 1GHz. I don't know if it is standard practice and if
Intel and AMD are doing it too.

Things worth checking: disable PREEMPT, change it to "Voluntary preemption". 
Check if using conservative governor makes any difference. I know that 
this may sound strange, but transition latency is directly proportional to 
difference between current and destination frequency. Maybe for faster 
processors it isn't allowed to change frequency directly from min to max?

Rafa³



----------------------------------------------------------------------
NIE KUPUJ!!!
...zanim nie porownasz cen >> http://link.interia.pl/f1a5e



