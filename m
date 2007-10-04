Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbXJDHK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbXJDHK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXJDHKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:10:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:35328 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXJDHKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=odFDC5DV1b/tAbKAQUOBvB6ce66Gqih/lpkWhcJqQJny7t5Yd/J8grCop1fdrAmqLAsGx+e1ePvJbRbuI3ukCxSifBdep3wfXdQMcRJ9PFBMfAu1PfsGNbq3Lv6gjCeP/4HgzYL9T/ArKNrZctTh9m9x34KsPhh9Zbmk+7x4c78=
Message-ID: <84144f020710040010r4804c69x746bf78db17e9fa1@mail.gmail.com>
Date: Thu, 4 Oct 2007 10:10:10 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [Bug] 2.6.23-rc9 - kernel BUG at mm/slab.c:592!
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       samba-technical@lists.samba.org,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
In-Reply-To: <47048DD8.2090405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47048DD8.2090405@linux.vnet.ibm.com>
X-Google-Sender-Auth: 9fcd6b93adda82c1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On 10/4/07, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Kernel bug hit, while running fsstress over the CIFS mounted partition on
> the ppc64 machine
>
> cpu 0x0: Vector: 700 (Program Check) at [c000000106ec75f0]
>
>     pc: c0000000000d69cc: .kmem_cache_free+0xac/0x154
>
>     lr: c0000000000b05f0: .mempool_free_slab+0x1c/0x30
>
>     sp: c000000106ec7870
>
>    msr: 8000000000029032
>
>   current = 0xc000000007cf64c0
>
>   paca    = 0xc0000000007ecf00
>
>     pid   = 8210, comm = fsstress
>
> kernel BUG at mm/slab.c:592!

Looks like someone passed a non-slab pointer to
mempool_free()/kmem_cache_free() so it's likely that the problem is in
cifs, not mm.

                                             Pekka
