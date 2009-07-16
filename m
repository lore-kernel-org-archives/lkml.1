Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbZGPUsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbZGPUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbZGPUsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:48:52 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:59614 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbZGPUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:48:51 -0400
Message-ID: <4A5F91F4.5070505@ece.cmu.edu>
Date: Thu, 16 Jul 2009 16:47:48 -0400
From: Raj Rajkumar <raj@ece.cmu.edu>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "James H. Anderson" <anderson@cs.unc.edu>
CC: Ted Baker <baker@cs.fsu.edu>, Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       "Linux RT <linux-rt-users@vger.kernel.org> Fabio Checconi" 
	<fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Karthik Singaram Lakshmanan <lakshmanan@cmu.edu>,
       Dionisio de Niz <dionisio@sei.cmu.edu>
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the Linux-kernel]
References: <4A5F7254.3020809@ece.cmu.edu> <alpine.LRH.2.00.0907161513050.3814@anderson.cs.unc.edu> <4A5F806D.6040701@ece.cmu.edu> <alpine.LRH.2.00.0907161538340.3814@anderson.cs.unc.edu>
In-Reply-To: <alpine.LRH.2.00.0907161538340.3814@anderson.cs.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.7.16.203316
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1900_1999 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim:

Good discussion.   THanks for taking the time to educate me on past 
exchanges.

 > We didn't talk about the low processor utlization (Dhall effect)
 > mentioned in your last email.  However, that applies to hard real-time
 > workloads, not soft real-time workloads.  This discussion has been
 > touching on both.

For hard real-time workloads, partitioning (static binding to specific 
processors) works well, with developer control over where tasks run and 
their contenders.  For soft real-time workloads, global scheduling 
(dynamic binding to available processors) should do well.   The 
situation is analogous to what we see in banks and airports.  There is a 
common global queue serviced by multiple counters for "soft" real-time 
customers, and for those (business or first-class/special) customers 
needing higher QoS,  separate queues are provided.  In the OS context, 
we need to ensure that the two queues/servers do not interfere.  
Ceilings would help even when the hard and soft real-time tasks use the 
same processors.

However, the question of dealing with mutexes shared by processes 
allocated to different processors remains.  As Ted has pointed out, 
avoiding them would be best!  In practice, moving them to a 
synchronization processor (as was pointed out by Peter? and also 
discussed in one of my earlier papers on synchronization on 
multi-processors) ought to be considered.  I think the first-order 
improvements are
from

(1) ensuring that task waiting times are bounded as a function of 
critical sections only (i.e. avoiding the "unbounded" priority inversion 
problem) - this is accomplished by having critical sections execute at 
ceiling priorities (or higher) in the multiprocessor case,
(2) avoiding the wait from very long critical sections used only by 
lower-priority tasks - using priority ceilings instead of higher 
priority values for long critical sections mitigates this problem.
 
---
Raj



