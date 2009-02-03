Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZBCQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZBCQ61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZBCQ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:58:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:48285 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZBCQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wzejFZmQvIOaMuTf/SJVy0g71GlWi4dE5cFki1DsBoczdjEZQIqzqOuKmfCAVEaSDO
         GFpvvrr33LqNFyPTzj0hPyuXzQe7AU0Xb6XhF8YGIr2tcIgXwpfn5AJvl49+PcyxqQZQ
         RcyfvgBy+1fcmhX1toK3lakSbHHh525LDgKIc=
MIME-Version: 1.0
In-Reply-To: <20090203121147.GB19979@elte.hu>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	 <20090203121147.GB19979@elte.hu>
Date: Tue, 3 Feb 2009 17:58:13 +0100
Message-ID: <c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch 
	added to -mm tree
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>, Mike Travis <travis@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mm-commits@vger.kernel.org,
       rusty@rustcorp.com.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/3 Ingo Molnar <mingo@elte.hu>:
>
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
>> ------------------------------------------------------
>> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
>> From: Andrew Morton <akpm@linux-foundation.org>
>>
>> The various implemetnations and proposed implemetnations of work_on_cpu()
>> are vulnerable to various deadlocks because they all used queues of some
>> form.
>>
>> Unrelated pieces of kernel code thus gained dependencies wherein if one
>> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
>> also takes, the kernel could rarely deadlock.
>>
>> Fix this by creating a short-lived kernel thread for each work_on_cpu()
>> invokation.
>>
>> This is not terribly fast, but the only current caller of work_on_cpu() is
>> pci_call_probe().
>
> hm, it's quite ugly as well, and wasteful with resources.


Sorry I don't see the patch but only the changelog.
So perhaps my answer will be a bit out of sync.

But if pci_call_probe() is the only caller, so it is supposed to be
called only on boot.
Perhaps the work_on_cpu thread can be killed after boot up and then
become a thread created
on the fly after that if needed....

Or perhaps it's too much complex.....
