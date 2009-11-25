Return-Path: <linux-kernel-owner+w=401wt.eu-S1751785AbZKYG11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbZKYG11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZKYG10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:27:26 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:19995 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZKYG10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:27:26 -0500
X-IronPort-AV: E=Sophos;i="4.47,284,1257138000"; 
   d="scan'208";a="7930961"
Message-ID: <4B0CCE4A.5000602@analog.com>
Date: Wed, 25 Nov 2009 14:27:22 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Shredder/3.0
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <20091125061640.GB17203@shareable.org>
In-Reply-To: <20091125061640.GB17203@shareable.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 06:27:22.0211 (UTC) FILETIME=[58953330:01CA6D98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 02:16 PM, Jamie Lokier wrote:
> Mike Frysinger wrote:
>> From: Jie Zhang<jie.zhang@analog.com>
>>
>> The mmu code uses the copy_*_user_page() variants in access_process_vm()
>> rather than copy_*_user() as the former includes an icache flush.  This is
>> important when doing things like setting software breakpoints with gdb.
>> So switch the nommu code over to do the same.
>
> Reasonable, but it's a bit subtle don't you think?
> How about a one-line comment saying why it's using copy_*_user_page()?
>
> (If it was called copy_*_user_flush_icache() I wouldn't say anything,
> but it isn't).
>
But I think it's well known in Linux kernel developers that 
copy_to_user_page and copy_from_user_page should do cache flushing. It's 
documented in Documentation/cachetlb.txt. I don't think it's necessary 
to replicate it here.


Jie
