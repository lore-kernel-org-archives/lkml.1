Return-Path: <linux-kernel-owner+w=401wt.eu-S932477AbXHAT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbXHAT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXHAT02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:26:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61536 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXHAT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:26:27 -0400
Message-ID: <46B0DE5D.7040503@impulze.org>
Date: Wed, 01 Aug 2007 21:26:21 +0200
From: Daniel Mierswa <impulze@impulze.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Gericom Webboy Laptop Mouse/Touchpad
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1887Xg0W/Oer6J2ZtAwWZ+8+ScOil9Oa2yeLGM
 +TAIRSVWZSkbF9U6PIprDbrN/pehCK9Pql7ufqIrLr+rEEiRUn
 pDeoWLun3kzKlXAOWFu9w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks for the quick response.

> Or maybe run oprofile to try to figure out any abnormal system load?

> vmstat may provide some initial information as to what kind of activity
> exactly causes this issue.
I'm sorry. I'm not familar with those applications to get any useful 
information out of them. Any quick information on what i should be doing 
with it would be appreciated.


> Hmm, I'm pondering what I'd do here...
> Could it be that you're using the "old" IDE layer (not libata yet) and
> hdparm -u or -d or -c is inconveniently set up?

> Try configuring a different CONFIG_HZ?

> And did you try running a "barebone"-only configuration? Possibly some
> certain driver is causing this misbehaviour...
I'm already keeping the config as clean and minimal as i can imagine.

Anyway... I recompiled the kernel (2.6.22.2 now) with pure libata, 
CONFIG_HZ to 1000 (instead of 250). No effect yet.


> Or maybe it's a simple X.org scheduling issue again?
> What nice value do you run X.org at?
I'm using the default niceness which should be 10 no? I'm not re-nicing 
X if that was the question.


> In this context it would be good to ask about possible memory pressure on
> this system, too, since recently some people indicated more fluid X.org mouse
> pointer operation when mlocking the pointer handling code to avoid
> paging this code.
Well the system is low on memory (312M) but that was the last thing i 
would've been looking for since it somehow got the win32 gui and some 
games to render and work properly on it.


> Maybe run powertop to identify timer anomalies?
This shows two interesting lines:
   56.5% ( 21.6)       <interrupt> : extra timer interrupt
   11.0% (  4.2)       <interrupt> : libata


> Oh, given that IIRC the Webboy is a slightly older Gericom model which
> thus may easily be a (somewhat hotter) P4 *desktop* CPU
It's a pentium-3.
   model name      : Pentium III (Coppermine)
   stepping        : 10
   cpu MHz         : 1097.269


> could it be that
> you're hitting thermal emergency throttling on increased system activity?
> cat /proc/acpi/processor/*/throttling or something there might indicate
> this.
When am I supposed to check this? During idle it's like the following:
   state count:             8
   active state:            T0
   states:
      *T0:                  00%
       T1:                  12%
       T2:                  25%
       T3:                  37%
       T4:                  50%
       T5:                  62%
       T6:                  75%
       T7:                  87%

Any additional comments on this? :)
Thanks a lot.

-- 
MfG
Mierswa, Daniel
