Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXCRKmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXCRKmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbXCRKmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:42:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:55893 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbXCRKmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:42:04 -0400
Message-ID: <45FD1778.6030602@argo.co.il>
Date: Sun, 18 Mar 2007 12:42:00 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Anthony Liguori <aliguori@us.ibm.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com> <20070316150145.GB8525@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070316150145.GB8525@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
>>>  
>>>       
>> What benefit would a syscall interface have?
>>     
>
> Another thing is that this patch set already introduces a way to pass a
> sigset. Passing a sigset to a device node is sort of strange.
>   

The sigset is passed to the device node just for safekeeping, as it 
doesn't normally change.  It's only used when switching to guest mode.

> In addition, if we would port kvm to s390, then we would need to
> make sure that each virtual cpu only gets executed from the thread
> that created it. That is simply because the upper half of our page
> tables contain information about the guest page states. This is yet
> another thing that would be strange to do via an ioctl based interface.
>   

Right.  I agree it's more natural to associate a vcpu with a task 
instead of a vcpu being an independent entry.  We'd still need a handle 
for it, and in Linux that's an fd (pid doesn't cut it as it's racy, and 
probably slower too as it has to go through a global structure).

> Of course everthing can be done via an iotcl interface too, but IMHO
> that's just the wrong interface.
>   

I guess once we have smp, and preferably an additional arch port, we can 
do another round of API consolidation around a syscall based API.  We'll 
need to support the ioctl based API in parallel until the distros flush 
out older userspace.

-- 
error compiling committee.c: too many arguments to function

