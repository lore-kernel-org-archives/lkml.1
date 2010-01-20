Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481Ab0ATXMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0ATXMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287Ab0ATXMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:12:25 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53804 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0ATXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:12:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T73GP6ypL/KoTTFFhhEw/lmj7dFaUDQ/F6FJQsgPZs6T0NQKc8a3InHxB12AITEfrX
         edqb7howNzru8l9itsMlekvzovpTxUGgI4HnZH5ImzjD09JtNgaj1mDv31yGxxFECP/t
         fCUkP/jNhwACTRfBwqU5VKiR+l73RtXA4x1Bg=
Message-ID: <4B578DD4.90908@suse.cz>
Date: Thu, 21 Jan 2010 00:12:20 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       x86@kernel.org, stable@kernel.org
Subject: Re: [PATCH] bootmem: avoid DMA32 zone by default
References: <20100120153000.GA13172@cmpxchg.org> <1264027998-15257-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1264027998-15257-1-git-send-email-hannes@cmpxchg.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:53 PM, Johannes Weiner wrote:
> I cc'd stable because this affects already released kernels.  But since this is
> the first report of DMA32 memory exhaustion through bootmem that I hear of,

Just for how the setup look like:
128G of RAM, flat mapping
sizeof(struct page)=56
0-1.75G mem_map
1.75-2G vfs caches, console and others. initrd reservation
2-4G reserved by BIOS

Kernel panics with out of memory when swiotlb tries to allocate 64M of
"low" bootmem.

-- 
js
suse labs
