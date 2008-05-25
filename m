Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYEYRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYEYRAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbYEYRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:00:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38782 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbYEYRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Bm0H2lWeLhBRYztePMrnzJaRrLbhueVLPqwSBdp0gwdWBG+gAvHUAyEBuvZyDuK4BO+f3ePZwWN4bjAifkvgfBx3aydE2vuMk1P1PwVyouwyDEOGZ26oWDMse9Xb1nBAD3hGM3o7xS3PhbJjViTGgI1xQwy+bCHsnOHvFbc3UYw=
Date: Sun, 25 May 2008 21:00:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] tip/x86/nmi nmi-32/64.c merge v3
Message-ID: <20080525170004.GA6911@cvg>
References: <4838373b.0637560a.7ce5.3f01@mx.google.com> <alpine.LFD.1.10.0805251842360.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805251842360.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Gleixner - Sun, May 25, 2008 at 06:44:28PM +0200]
| On Sat, 24 May 2008, Cyrill Gorcunov wrote:
| 
| > This series tries to merge down nmi_32/64.c to nmi.c. It is done by small
| > steps in hope it would help to bisect problems (which will appear anyway ;)
| > Please review *carefully* since it is NMI what I've touched (and I'm not
| > nmi specialist). So I really apreciate _ANY_ comments on this. The series
| > is produced over today 'tip' tree branch 'x86/nmi'.
| 
| Cyrill,
| 
| very good job. I did a short review and found no obvious problems
| yet. Will have a closer look when I apply it.
| 
| Thanks,
| 	tglx
| 
| 
| 

thanks Thomas, unfortunelly I think the problems will arise soon,
I've just noticed the commit 

commit 57b2b8947a5f68e59d5f50ab749efdc79d9ba040
Author: Mike Travis <travis@sgi.com>
Date:   Mon May 12 21:21:12 2008 +0200

    x86: fix remove cpu_pda table patch

in tip/testing tree

so we will need some workaround for check_nmi_watchdog() 'cause of  changing

...
-	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
+	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
...
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
...

didn't take a precise look on this, but will take as only be able to ;)

		- Cyrill -
