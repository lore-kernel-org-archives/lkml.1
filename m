Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYFJGzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYFJGzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYFJGze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:55:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38172 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYFJGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:55:33 -0400
Message-ID: <484E258F.4090103@bull.net>
Date: Tue, 10 Jun 2008 08:56:15 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Solofo.Ramangalahy@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC -mm 0/6] sysv ipc: scale msgmnb with the number of cpus
References: <20080606060955.317871352@bull.net>
In-Reply-To: <20080606060955.317871352@bull.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solofo.Ramangalahy@bull.net wrote:
> The size in bytes of a SysV IPC message queue, msgmnb, is too small
> for large machines, but we don't want to bloat small machines
> 
> Several methods are used already to modify (mainly increase) msgmnb:
> . distribution specific patch
> . system wide sysctl.conf
> . application specific tuning via /proc/sys/kernel/msgmnb
> 
> Integrating this series would:
> . reflect hardware and software evolutions and diversity,
> . reduce configuration/tuning for the applications.
> 
> Here is the timeline of the evolution of MSG* #defines:
> Year             1994         1999         1999          2008
> Version           1.0       2.3.27       2.3.30        2.6.24
> #define MSGMNI    128          128           16            16
> #define MSGMAX   4056         8192         8192          8192
> #define MSGMNB  16384        16384        16384         16384
> 
> This patch series scales msgmnb, with respect to the number of
> cpus/cores for larger machines. For uniprocessor machines the value
> does not increase.
> 
> This series is similar to (and depends on) the series which scales
> msgmni, the number of IPC message queue identifiers, to the amount of
> low memory.
> While Nadia's previous series scaled msgmni along the memory axis,
> hence the message pool (msgmni x msgmnb), this series uses a second
> axis: the number of online CPUs.
> As well as covering the (cpu,memory) space of machines size, this
> reflects the parallelism allowed by lockless send/receive for
> in-flight messages in queues (msgmnb / msgmax messages).
> 
> The initial scaling is done at initialization of the ipc namespace.
> Furthermore, the value becomes dynamic with respect to cpu hotplug.
> 
> The msgmni and msgmnb values become dependent, as the value of msgmni
> is computed with respect to the value of msgmnb.
> 
> The series is as follows:
> . patch 1 introduces the scaling function 
> . patch 2 deals with cpu hotplug
> . patch 3 allows user space to disable the scaling mechanism
> . patch 4 allows user space to reenable the scaling mechanism
> . patch 5 finer grain disabling/reenabling scaling mechanism
>           (disconnect msgmnb and msgmni)
> . patch 6 adds documentation
> 

Solofo,

Patches 3 and 4 are useless imho. If you really really want to keep 
them, you should at least merge them.

Regards,
Nadia
