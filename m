Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZLBPIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZLBPIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZLBPII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:08:08 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39155 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbZLBPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:08:06 -0500
X-IronPort-AV: E=Sophos;i="4.47,328,1257138000"; 
   d="scan'208";a="9808368"
Message-ID: <4B1682B9.406@analog.com>
Date: Wed, 2 Dec 2009 23:07:37 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091202 Shredder/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <16399.1259765124@redhat.com>
In-Reply-To: <16399.1259765124@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Dec 2009 15:08:07.0265 (UTC) FILETIME=[40FA5510:01CA7361]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 10:45 PM, David Howells wrote:
> Mike Frysinger<vapier@gentoo.org>  wrote:
>
>> The mmu code uses the copy_*_user_page() variants in access_process_vm()
>> rather than copy_*_user() as the former includes an icache flush.  This is
>> important when doing things like setting software breakpoints with gdb.
>> So switch the nommu code over to do the same.
>
> Note that we may only really want to do an icache flush if the target region
> is mapped executable somewhere.  On the other hand, for debugging stuff on an
> embedded board, it probably doesn't matter.
>
It is not checked before icache flush even for MMU. This is a place we 
can do some improvement. But it's not important for debugging.


Jie
