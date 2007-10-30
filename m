Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbXJ3JuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbXJ3JuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXJ3Jt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:49:58 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21690 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXJ3Jt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:49:57 -0400
Message-ID: <4726FE2A.1040607@siemens.com>
Date: Tue, 30 Oct 2007 10:49:30 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Carsten Emde <Carsten.Emde@osadl.org>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com>	<4726B088.1010709@qumranet.com> <4726DF66.4000000@osadl.org>
In-Reply-To: <4726DF66.4000000@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Emde wrote:
> Avi Kivity wrote:
>> David Brown wrote:
>>> I thought I'd try out the realtime patch set and it didn't work at all
>>> with kvm. The console didn't dump anything and the system completely
>>> locked up.
> Up to now, the unmodified kvm module never worked with any RT kernel. 
> This would only change, if RT patched kernels were routinely used in the 
> kvm release tests which is, for the time being, not the case.

As far as I understood (but didn't re-test yet), latest kvm release does
include all features required to run over -rt. This was at least the
case for kvm-git I picked up last week and merged into 2.6.23-rt1. The
only issue is that out-of-tree kvm doesn't enable the preemption
notifiers (maybe there were one or two further minor issues, I think to
recall missing smp_ops exports being one, but these were not -rt related).

> 
> However, tglx once provided a hand-crafted kvm version that can be used 
> together with a selected RT kernel -> see "Latest Stable" 
> (http://www.osadl.org/Latest-Stable.latest-stable-realtime-kernel.0.html) 
> realtime kernel. It is based on kernel 2.6.21.6-rt21 and kvm-28.
> 
> We used these modules to carry out a number of "proof of concept" tests 
> which were very successful. The realtime capabilities of the host system 
> remained unchanged irrespective of whether the kvm guest system (no 
> graphics) was running or not. This was even the case while the guest 
> system was booting.

Interesting result - you've read about the wbinvd issues? Is there no
wbinvd in the bios shipped with older kvm? Which VM extension did you
test, both Intel and AMD? I would bet that your X issues are due to the
same effect. X startup/shutdown involves a lot of wbinvd calls on my
test boxes.

To sum up my findings: kvm over whatever RT kernel is risky
(latency-wise) unless you can audit or even para-virtualise your guest
OS /wrt wbinvd. Maybe we can discuss this also in Linz by the end of the
week. :)

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
