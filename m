Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYFLQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYFLQiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYFLQiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:38:08 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:65283 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYFLQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L6wC0LFikEOL+kIa90auWvOd6uXHFpphPjb4l5kZDCrkokdd9cRFKs6DiPphvJtSbZ
         2PBCfHf5fKc78ijdpH9jKX+b+m5df+c5b/uW3ZpeMqzo1qD++GC+VCjKUhV706IGks0P
         Qd+vNbeJ775nqSWhi0fIhsJrVFM7fP3CZg3NQ=
Message-ID: <1ba2fa240806120938i248d38bek2a9155defff9428f@mail.gmail.com>
Date: Thu, 12 Jun 2008 19:38:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Rik van Riel" <riel@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <c4e36d110806120712h1237d084v2eaeb494cc48b43c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <c4e36d110806120712h1237d084v2eaeb494cc48b43c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 5:12 PM, Zdenek Kabelac
<zdenek.kabelac@gmail.com> wrote:
> 2008/6/12 Johannes Berg <johannes@sipsolutions.net>:
>> On Thu, 2008-06-12 at 09:38 -0400, Rik van Riel wrote:
>>> On Thu, 12 Jun 2008 12:07:34 +0200
>>> "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
>>>
>>> > It looks like while there was a huge amount of buffers and caches -
>>> > system was unable to allocate few pages for kmalloc in iwl3945 driver
>>> > after resume.
>>>
>>> It looks like this is because it wants to allocate 2**5 contiguous
>>> pages, which is 128kB of contiguous kernel memory.
>>
>> 64-bit system I assume?
>> The allocation should be 256 * 20 * sizeof(struct sk_buff *).
>>
>> Try the patch below. It should improve code generation too.
>
> I'll surely try you patch - but is the iwl the only driver which needs
> 128kB continuous memory chunk?

We do some stupid free-alloc sequence on restart this is where it
fails. I'm still polishing a patch that eliminates it.
Tomas
