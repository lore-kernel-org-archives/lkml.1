Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZI3SBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZI3SBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZI3SBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:01:39 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:45225 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZI3SBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:01:38 -0400
Message-ID: <4AC39CE5.9080908@free.fr>
Date: Wed, 30 Sep 2009 20:01:09 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr> <87eipoo0po.fsf@caffeine.danplanet.com>
In-Reply-To: <87eipoo0po.fsf@caffeine.danplanet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Smith wrote:
> DL> If the checkpoint is done from the kernel, why the restart
> DL> wouldn't be in the kernel too ?
>
> I think thus far we have taken the approach of "if it can be done
> reasonably in userspace, then do it there" right?  
Well I am a little lost :)
The tty CR can be "reasonably" done in userspace I think. But it was 
done in the kernel, no ?

> Setup of the
> network devices is easy to do in userspace, allows more flexibility
> from a policy standpoint, and ensures that all existing security
> checks are performed. 
Yep, I agree. But you didn't answer the question, what are the network 
resources you plan to checkpoint / restart ?
eg. you let the container to setup your network, will you restore netdev 
statistics ? the mac address ? ipv4 ? ipv6 ?

Is it possible to do a detailed list of network resources you plan to CR 
with the different items you will address from userspace and kernel space ?

> Also, migration may be easier if the userspace
> bits can call custom hooks allowing for routing changes and other
> infrastructure-specific operations.
>   
You may have some problems with the connected sockets you will restore 
in this case.

> DL> Is there any documentation about the statefile format I can use if
> DL> I want to implement myself an userspace CR solution based on this
> DL> kernel patchset ?
>
> See linux-cr/include/linux/checkpoint_hdr.h and user-cr/restart.c.
>   
Argh ! I was hoping there was something else than the source code :)

Thanks
  -- Daniel

