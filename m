Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXGJHA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXGJHA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXGJHAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:00:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:29170 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXGJHAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:00:19 -0400
Message-ID: <46932E57.7040203@openvz.org>
Date: Tue, 10 Jul 2007 10:59:35 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org> <20070709120236.GC4509@MAIL.13thfloor.at> <46923521.4040109@openvz.org> <20070709195240.GA27189@MAIL.13thfloor.at> <46929691.8050103@fr.ibm.com>
In-Reply-To: <46929691.8050103@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
>>>>> 3. Suka assumes that pid namespace can live without proc mount
>>>>>    and tries to make the code work with pid_ns->proc_mnt change
>>>>>    from NULL to not-NULL from times to times.
>>>>>    My code calls the kern_mount() at the namespace creation and
>>>>>    thus the pid_namespace always works with proc.
>>>> shouldn't that be done by userspace instead?
>>> It can be. But when the namespace is being created there's no
>>> any userspace in it yet.
>> I'm not talking about the 'userspace inside the space'
>> I'm talking about the userspace creating the space
>> (what if I do not want to have any proc mount?)
> 
> yes, can't we let the user doing the unshare or clone decide whether
> it needs to mount /proc or not in the new pid namespace ?
> 
> that's already optional on the host. 

If we admit that the pid_ns->proc_mnt pointer can change from NULL
to some valid mount, then we should track all the possible races
with its dereference in the code. We have already caught one of 
such "tricky" places with Suka's patches and sent the OOPs to him.

My opinion is that having kern_mount-ed proc makes no discomfort but
protects from all the possible races with this pointer dereferencing.

Thanks,
Pavel

> C.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

