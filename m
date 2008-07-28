Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYG1Umr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYG1Umr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYG1Umj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:42:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:55178 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYG1Umi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=bAgRi0BIim9aHTqB/2y+b/Cjn5yN5eVbpt75PMl3wB8Sw/u0J/Eren4cM2Nx5IAWVt
         k97QFFtDsll0AzYsgR53J7qYczGwmiqlwq/BhBeTyNmkoALJiLmGfJ8UvA46kyQ69ycf
         SpFGDIbKha0ITdSyu6qcpvdllXEJBljXeP23Y=
Message-ID: <84144f020807281342t2e1a3dc3id01314ac01de406f@mail.gmail.com>
Date: Mon, 28 Jul 2008 23:42:37 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of memory
Cc: "Eric Sandeen" <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com, stable@kernel.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <20080728133504.156f438f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488DF00F.3080809@redhat.com>
	 <20080728133504.156f438f.akpm@linux-foundation.org>
X-Google-Sender-Auth: 677f15235277cac1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:35 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 28 Jul 2008 11:13:03 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
>
>> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
>> when testing eCryptfs.  The root cause turned out to be that eCryptfs
>> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
>> as a nice page-aligned chunk of memory.  But at least with SLUB debugging
>> on, this is not always true, and the page we get from virt_to_page does
>> not necessarily match the PAGE_CACHE_SIZE worth of memory we got from
>> kmalloc.
>>
>> My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
>> 2 different multi-megabyte files.  With this change I no longer see
>> the corruption.
>
> The fix applies to both 2.6.25 and to 2.6.26 and appears to be needed
> in both kernel versions, so I have tagged it for backporting into both.

Hmm, SLUB will use the page allocator directly for PAGE_CACHE_SIZE
regadless of whether debugging is enabled or not...
