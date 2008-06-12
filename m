Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbYFLOM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbYFLOM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759850AbYFLOMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:12:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:30496 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYFLOMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qRtsStlSJesQ6RIz916odPZ9SwqeUfArEXZK442Ody+t/prKosP9W4k7Ktdki3nXvX
         bJYefy/kPmJvAAtfrKoXg7foh4Fw+9OgoYBSBntCUZRoAo7v2hdPijVGeBuv+4QRFDeW
         fp7pgVqd2It3RBa6XA8pHuCy2e7v6v1flp0+g=
Message-ID: <c4e36d110806120712h1237d084v2eaeb494cc48b43c@mail.gmail.com>
Date: Thu, 12 Jun 2008 16:12:18 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213278884.3936.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/12 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2008-06-12 at 09:38 -0400, Rik van Riel wrote:
>> On Thu, 12 Jun 2008 12:07:34 +0200
>> "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
>>
>> > It looks like while there was a huge amount of buffers and caches -
>> > system was unable to allocate few pages for kmalloc in iwl3945 driver
>> > after resume.
>>
>> It looks like this is because it wants to allocate 2**5 contiguous
>> pages, which is 128kB of contiguous kernel memory.
>
> 64-bit system I assume?
> The allocation should be 256 * 20 * sizeof(struct sk_buff *).
>
> Try the patch below. It should improve code generation too.

I'll surely try you patch - but is the iwl the only driver which needs
128kB continuous memory chunk?

I think that if the 128kB memchunks are exhausted in 2 days while
there is over 1GB of free RAM in buffers & caches I think some
defragmentation is needed then ?

btw: Does it really means that within those buffers kernel could not
find any adjacent 32 pages which could be made free ?

Zdenek
