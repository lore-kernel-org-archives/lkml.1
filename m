Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYJUJg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYJUJg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYJUJgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:36:21 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:51297 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYJUJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:36:20 -0400
Message-ID: <48FDA28B.30204@fr.ibm.com>
Date: Tue, 21 Oct 2008 11:36:11 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Daniel Lezcano <dlezcano@fr.ibm.com>, Louis.Rilling@kerlabs.com,
       containers@lists.linux-foundation.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1224286383.1848.65.camel@nimitz>	<20081020111002.GQ15171@hawkmoon.kerlabs.com>	<48FC86B2.8000606@fr.ibm.com> <48FCA97C.1040108@cs.columbia.edu>
In-Reply-To: <48FCA97C.1040108@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> IMHO we should look at Dmitry patchset and merge the external checkpoint 
>> code to Oren's patchset in order to checkpoint *one* process and have 
>> the process to restart itself. At this point, we can begin to talk about 
>> the restart itself, shall we have the kernel to fork the processes to be 
>> restarted ? shall we fork from userspace and implement some mechanism to 
>> have each processes to restart themselves ? etc...
>>
> 
> In both approaches, processes restart themselves, in the sense that a
> process to be restarted eventually calls "do_restart()" (or equivalent).
> 
> The only question is how processes are created. Andrew's patch creates
> everything inside the kernel. I would like to still give it a try outside
> the kernel. Everything is ready, except that we need a way to pre-select
> a PID for the new child... we never agreed on that one, did we ?

what do you mean ? like a clone_with_pid() routine ? 

> If we go ahead with the kernel-based process creation, it's easy to merge
> it to the current patch-set.

Both solution are valid. Nevertheless, I would choose the solution 
sharing existing code and being arch independent.

Now, we can start by duplicating code and see later how we could
share. But for mainline inclusion, I think that code reuse is a
faster path.

C.
