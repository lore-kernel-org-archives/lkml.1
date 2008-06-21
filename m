Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYFUTQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYFUTQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFUTQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:16:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:5662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYFUTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=hJYxePbCA98V2GbyJiQozlkJSqQTyMHlIXngvedU8LWAkDGK2MXsP3sm7H8UGcTcVI
         1ii4I8dnx2xATVX/WmWfDXdQbr1gXklY9a19Ztpv1G14YetAlFSK361Trjqf1dZwOdV9
         ANsPnWWjevk4fiuTpfHCunf2rM4nKb4qQJvRw=
Message-ID: <19f34abd0806211216y4695c532ndb4935082bd8ea1@mail.gmail.com>
Date: Sat, 21 Jun 2008 21:16:37 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: v2.6.26-rc7: Negative powertop values
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was testing v2.6.26-rc7 by running lmbench and hotplug/-unplugging
CPUs and a few other programs at the same time. Powertop was showing a
negative number of wakeups/second and average C3 residency was
something really insane. Is there anything strange with this schedstat
file, or is there another file I should look at that can explain the
strange powertop numbers? Or maybe it's just an artifact of powertop
and this has nothing to do with the kernel?

    powertop:

    Cn                Avg residency       P-states (frequencies)
    C0 (cpu running)        (105.5%)        1467 Mhz    80.7%
    C1                0.0ms ( 0.0%)         1067 Mhz     0.4%
    C2                0.0ms ( 0.0%)          800 Mhz    19.0%
    C3                0.0ms (1288344194138.5%)

    Wakeups-from-idle per second : -6.2     interval: 2.0s


    # cat /proc/schedstat
    version 14
    timestamp 811305
    cpu0 0 0 0 545 0 5733898 257804 3325833 3064649 6916730262519
21980606970853 5438836
    domain0 <NULL> 1514 1081 425 452096 12 10 0 1081 91 91 0 0 0 0 0
91 5916 4168 1715 1859096 34 13 4 4164 4 0 4 0 0 0 0 0 0 1013 18883 0
    cpu1 0 0 0 1279 0 12508366 1294362 7173738 6484092 1515315020607
22231002791887 11146865
    domain0 <NULL> 313 219 88 154083 10 3 0 219 104 104 0 527 0 0 0
104 1077 894 163 467031 41 5 0 894 1 0 1 0 0 0 0 0 0 455 14689 0


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
