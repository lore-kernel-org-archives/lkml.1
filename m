Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZDBSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZDBSCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZDBSCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:02:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:46017 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZDBSCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=irlqrvgoE/9i78q84ZcODIH0RveUgvvj0mHSk1R9oc664Rbztob63L6rgZEZCKdy1z
         dV+jADvfqE6iPAu/3eo+W4ujkil2PsbmRlurd48LNmbNnKjF/Tl9UZ6jiKhvFDeTG7p/
         pWZLrZVnjdk4oy3Oh7IWV0gd7aPZlH58FfS24=
MIME-Version: 1.0
In-Reply-To: <20090402095315.1098b6c3.akpm@linux-foundation.org>
References: <1238690835.7359.16.camel@lts-notebook>
	 <20090402095315.1098b6c3.akpm@linux-foundation.org>
Date: Fri, 3 Apr 2009 03:02:41 +0900
X-Google-Sender-Auth: 1f6577e31b4732cd
Message-ID: <2f11576a0904021102r19165d89le45563b438621e08@mail.gmail.com>
Subject: Re: [PATCH] Define a UNIQUE value for AS_UNEVICTABLE flag
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>,
       Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>,
       Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Avi)

>> [PATCH] Define UNIQUE value of AS_UNEVICTABLE
>>
>> Needed in 2.6.28, 2.6.29, ...
>>
>> A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
>> available AS flag while the Unevictable LRU was under development.  The
>> Unevictable LRU was using the same flag and "no one" noticed.  Current
>> mainline, since 2.6.28, has same value for two symbolic flag names.
>
> argh.
>
> What are the user-observable effects of the bug, and why didn't anyone
> notice it until now?

AS_MM_ALL_LOCKS is used by mmu_notifier. it mean it is used by only kvm.
In the other hand,  AS_UNEVICTABLE mean unevictable shmem or ramfs.

Then, if shmem opend process use ioctl(KVM_CREATE_VM), unevictable
flag on the shmem accidentally turn off.
but, fortunatelly, In modern desktop environment, only KVM control
program use above ioctl. then, we can assume this doesn't use shmem
and ramfs.

Am I missing anything?
