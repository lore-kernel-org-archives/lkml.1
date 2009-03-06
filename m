Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZCFGkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZCFGkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZCFGjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:39:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:57928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZCFGjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:39:55 -0500
Message-ID: <49B0C4F1.7080106@kernel.org>
Date: Thu, 05 Mar 2009 22:38:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <49B0BF46.4080405@zytor.com>
In-Reply-To: <49B0BF46.4080405@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> Impact: cleanup
>>
>> extend after_bootmem and after_init_bootmem to bootmem_state
>> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
>>
> 
> Wouldn't it make more sense to add these as system_state enumerations
> and use relational comparisons on them (< <= >= >)?

it is for fixing problem for x86 32/64 merging.
64bit after_bootmem: after bootmem is freed
32bit after_init_bootmem, after we got bootmem initialized.

and previous init_memory_mapping() merging wrongly rename after_init_bootmem to after_bootmem.

also there is after_paging_init, could be merged lated...

but may change bootmem_state to mm_state

YH
