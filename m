Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbXLOAvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbXLOAvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXLOAvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:51:31 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:27716 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbXLOAva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:51:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dL2AUhVcp2Oc7rCoV62L9hdvoUn4+bQp6qURMvqEaiScgDaKdQRlxE/KSayVzFgXUKf5fNXLVTfDdcaNiN/qC128JKOuyPkDeP4JwBCI2ZR3lL8ZpS7clhS6oDjI8qAJ9yk2VLVaV4HXbdWoPmBjpbpuSP7c4QO1O9SY2bQR/zM=
Message-ID: <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>
Date: Fri, 14 Dec 2007 19:51:28 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200712141817.47581.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>
	 <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>
	 <200712141817.47581.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 6:17 PM, Len Brown <lenb@kernel.org> wrote:
> does processor.max_cstate=1 make the failing configuration work?
> If yes, how about processor.max_cstate=2?

Until now 2 things were necessary to reproduce the problem -
1) CPU_IDLE=y and
2) Wakeups from Idle = 5-7 Per second (== Longer/deeper C state residency)

If I left the wakeups to high number (50-60) - there were no lockups
but it was very jerky over ssh.
(Typing keys had no effect for seconds etc.)

CPU_IDLE=y

With max_cstate=1 and CPU_IDLE=y things are pretty smooth - no lockups
for the last hour. (Soft lockups used to appear in minutes
previously.)

With max_cstate=2 - old story repeats - it's very jerky and soft
lockups appear in under a minute after going to 3-5 wakeups from idle
per sec.

>
> what do you see in /proc/acpi/processor/*/power?
>

Normally (without any max_cstate= parameter) I see this -
(I admit I never thought there was a C8 - C3 was all I ever heard.)

[parag@mini router]$ cat /proc/acpi/processor/CPU0/power
active state:            C2
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[C2] demotion[--]
latency[001] usage[00001010] duration[00000000000000000000]
   *C2:                  type[C2] promotion[--] demotion[C1]
latency[001] usage[07181700] duration[00000000379397304978]


Thanks
Parag
