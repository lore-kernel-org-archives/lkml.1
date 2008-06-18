Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYFRQMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYFRQMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYFRQMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:12:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:52193 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbYFRQME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=d/54HLCayWsqHpqBl6Hf64O/Gv8xJqNr97PFRJ5je1mS2RGMFy+yjCNwdsaxg9kU5d
         NPNaXxqUBVnKWGj+dmnoJL+Adx7jDApPaLcUDZg9HkZvD8/1zHbDW5i0fKYDLuTLtWJ8
         1Ici8UJpkF1ya/83kjbyAxhqP3ZCUv5QvqWBI=
Message-ID: <485933C7.8050801@gmail.com>
Date: Wed, 18 Jun 2008 18:11:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>, Mike Travis <travis@sgi.com>,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 1/1] MM: virtual address debug
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com> <20080618121221.GB13714@elte.hu> <20080618135928.GA12803@elte.hu>
In-Reply-To: <20080618135928.GA12803@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napsal(a):
> No NUMA configuration found
> Faking a node at 0000000000000000-000000003fff0000
> Entering add_active_range(0, 0, 159) 0 entries of 25600 used
> Entering add_active_range(0, 256, 262128) 1 entries of 25600 used
> Bootmem setup node 0 0000000000000000-000000003fff0000
>   NODE_DATA [000000000000a000 - 000000000003dfff]
> PANIC: early exception 06 rip 10:ffffffff80ba7531 error 0 cr2 f06f53
> Pid: 0, comm: swapper Not tainted 2.6.26-rc6 #7709
> 
> Call Trace:
>  [<ffffffff80b9c196>] early_idt_handler+0x56/0x6a
>  [<ffffffff80ba7531>] setup_node_bootmem+0x12a/0x2d4

Hmm, it's at
nid = phys_to_nid(nodedata_phys);
and
VIRTUAL_BUG_ON((addr >> memnode_shift) >= memnodemapsize);
triggers. Apparently memnodemapsize is not available for real numas. Going 
to remove the test and respin the patch with Nick's comment applied.

Thanks.
