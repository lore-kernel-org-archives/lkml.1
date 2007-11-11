Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbXKKKSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbXKKKSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 05:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXKKKSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 05:18:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:38842 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbXKKKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 05:18:38 -0500
Message-ID: <4736D6C0.8040408@qumranet.com>
Date: Sun, 11 Nov 2007 12:17:36 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com>
In-Reply-To: <11945615751747-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> This is the host part of kvm clocksource implementation. As it does
> not include clockevents, it is a fairly simple implementation. We
> only have to register a per-vcpu area, and start writting to it periodically.
>
>   

Missing live migration support  (a way for userspace to read and write 
the guest clock address).  Should probably be in a separate patch.

> @@ -1924,6 +1955,7 @@ out:
>  		goto preempted;
>  	}
>  
> +	kvm_write_guest_time(vcpu);
>  	post_kvm_run_save(vcpu, kvm_run);
>   

Why here?  Seems like we're leaving the guest for a while at this place.

Suggest putting it on top of __vcpu_run(), guarded by a flag, and 
setting the flag every time we put the vcpu.

 



-- 
error compiling committee.c: too many arguments to function

