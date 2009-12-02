Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZLBPAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZLBPAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZLBPAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:00:48 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:19059 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZLBPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:00:47 -0500
X-IronPort-AV: E=Sophos;i="4.47,328,1257138000"; 
   d="scan'208";a="9807780"
Message-ID: <4B168107.8020708@analog.com>
Date: Wed, 2 Dec 2009 23:00:23 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091202 Shredder/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <16225.1259764594@redhat.com>
In-Reply-To: <16225.1259764594@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 15:00:49.0129 (UTC) FILETIME=[3BD41590:01CA7360]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 10:36 PM, David Howells wrote:
> Mike Frysinger<vapier@gentoo.org>  wrote:
>
>> -			len -= copy_to_user((void *) addr, buf, len);
>> +			copy_to_user_page(vma, NULL, NULL,
>> +					  (void *) addr, buf, len);
>>   		else if (!write&&  vma->vm_flags&  VM_MAYREAD)
>> -			len -= copy_from_user(buf, (void *) addr, len);
>> +			copy_from_user_page(vma, NULL, NULL,
>> +					    buf, (void *) addr, len);
>
> Hmmm...  With this, len isn't updated anymore, and so it alters the return
> value of access_process_vm(), and means ptrace_readdata() won't now return
> -EIO under some circumstances where it used to.  I'm not sure that matters,
> though.
>
This keeps access_process_vm() in nommu.c align with the one in 
memory.c. If this does really matter, someone or me can write another 
patch to take care of it for both MMU and !MMU later.


Jie
