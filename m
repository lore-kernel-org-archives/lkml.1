Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYFKI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYFKI2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYFKI23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:28:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYFKI21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:28:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UN1mB3mHp/n9T757iDJp6edP4WM8Jg2lBHo0dvMulnC5I8sA1PProicZXCezr18i3
	zi0yCAENw/wYNLINPguCg==
Message-ID: <6599ad830806110128y24c9d222t44102e032198582c@mail.gmail.com>
Date: Wed, 11 Jun 2008 01:28:20 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] CPU controller statistics (v5)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, balajirrao@gmail.com,
       containers@lists.osdl.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl
In-Reply-To: <4847B3CB.5020700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603200515.GA25753@balbir.in.ibm.com>
	 <20080604144408.be680056.akpm@linux-foundation.org>
	 <4847B3CB.5020700@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 2:37 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> Can we avoid these tests?  By requiring that cgroup_subsys.initialize()
>> always be non-zero?  It might make sense, and it might not...
>>
>
> They are really hard to avoid, otherwise we might be taking away the flexibility
> we have.

And this is something that only gets called at startup.

>
>> Also, if this code is likely to be executed with any frequency then the
>> test of `early' could be inlined:
>>
>> static inline void cpu_cgroup_initialize(int early)
>> {
>>       if (unlikely(!early))
>>               __cpu_cgroup_initialize();
>> }
>>
>> yes?
>>
>
> Definitely

Er, no. It gets called twice at system boot (once with early=true and
once with early=false) via a vtable. So there's nothing to optimize
for, and making the function inline won't help since the compiler
needs to take its address.

Paul
