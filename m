Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbZAHRVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbZAHRVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZAHRU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:20:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:41306 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbZAHRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vu0DS3FvNVXJ5aoQ6onfb8ktNqybftV/Tu5BKjv1sYs44eJo7quFm5n8XsgFyu6reO
         q+YX7pyqqkVH9ra9hiI9SBb+qDpOGK78UqgbNKNTip3ZwEQnl6xgocteVNhqRzyzJM+I
         u7iLlUp6GjgQz7OkQM24gE6FblQvwcBdm9uNc=
Message-ID: <e9c3a7c20901080920r1051775ey7dbb4fad37b2810@mail.gmail.com>
Date: Thu, 8 Jan 2009 10:20:56 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] dmatest: flush and invalidate destination buffer before DMA
Cc: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, ralf@linux-mips.org
In-Reply-To: <20090108093603.691c1200@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081227111037.3bd13adc@hskinnemoen-d830>
	 <20081229.025352.01917409.anemo@mba.ocn.ne.jp>
	 <e9c3a7c20901051031y528d0d31r18d44c5096c59e0@mail.gmail.com>
	 <20090108.134336.127659765.nemoto@toshiba-tops.co.jp>
	 <20090108093603.691c1200@hskinnemoen-d830>
X-Google-Sender-Auth: 0de54733ec600c94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 1:36 AM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> I think it does. The dmatest driver should definitely use
> DMA_BIDIRECTIONAL on the destination buffer to ensure that the poison
> values are written to RAM and not just written to cache and discarded.
>

True.

> Now, this probably means that the destination buffer must be _unmapped_
> with DMA_BIDIRECTIONAL too, which is difficult to do with the current
> asymmetrical API...
>

A map and unmap should work for the current platforms with dma
drivers, but you are right I think this is a violation of the api.
For correctness we would need the entire operation covered by
DMA_BIDIRECTIONAL to support platforms that may implement a dma bounce
buffer.  Or, we could change dmatest to not go through the dma-memcpy
api, allowing dma_alloc to be used for the destination.

> In the general case, however, I think MIPS has a bug: I've seen drivers
> DMA to/from tiny buffers stored inside another struct. This is legal
> because the driver can guarantee that the other fields in the struct
> aren't accessed in the mean time, but any fields sharing a cacheline
> with the buffer must be written back before the lines are invalidated.
>

*nod*

--
Dan
