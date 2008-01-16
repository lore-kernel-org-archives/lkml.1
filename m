Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYAPTQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYAPTQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYAPTQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:16:07 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39545 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752484AbYAPTQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:16:06 -0500
Message-ID: <478E57F2.8010206@sgi.com>
Date: Wed, 16 Jan 2008 11:16:02 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: Change size of node ids from u8 to u16 V3
References: <20080116170902.006151000@sgi.com>	<20080116170902.328187000@sgi.com> <20080116185356.e8d02344.dada1@cosmosbay.com>
In-Reply-To: <20080116185356.e8d02344.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Another point: you want this change, sorry if my previous mail was not detailed enough :
>
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -78,7 +78,7 @@ static int __init allocate_cachealigned_memnodemap(void)
>         unsigned long pad, pad_addr;
>
>         memnodemap = memnode.embedded_map;
> -       if (memnodemapsize <= 48)
> +       if (memnodemapsize <= ARRAY_SIZE(memnode.embedded_map))
>                 return 0;
>
>         pad = L1_CACHE_BYTES - 1;
>

Hi Eric,

I'm still getting this message with the numa=fake=4 start option:

Faking node 0 at 0000000000000000-0000000028000000 (640MB)
Faking node 1 at 0000000028000000-0000000050000000 (640MB)
Faking node 2 at 0000000050000000-0000000078000000 (640MB)
Faking node 3 at 0000000078000000-000000009ff00000 (639MB)

NUMA: Using 27 for the hash shift.
Your memory is not aligned you need to rebuild your kernel
with a bigger NODEMAPSIZE shift=27 No NUMA hash function found.
NUMA emulation disabled.

Is there something else I need to change?  (This is on an AMD box.)

Thanks!
Mike


