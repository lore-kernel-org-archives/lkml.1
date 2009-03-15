Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbZCOG0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbZCOG0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCOG0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:26:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:45952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZCOG0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:26:39 -0400
Message-ID: <49BC9F74.2090500@kernel.org>
Date: Sat, 14 Mar 2009 23:25:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC5BCF.1070602@zytor.com> <49BC878D.5090402@kernel.org> <49BC8955.5070009@zytor.com> <49BC933F.3090507@kernel.org> <49BC9A9F.1090400@goop.org>
In-Reply-To: <49BC9A9F.1090400@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yinghai Lu wrote:
>> 64 bit does not has this problem.
>> 32 bit we already removed bootmem there, that is not needed.
>> ALLOCATOR_SLOP is needed...
>>
>> + *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
>> + *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
> 
> Yes, ALLOCATOR_SLOP is a different matter; its the amount of space the
> boot allocator needs for its own space management.  But 1) doesn't
> 64-bit need this too (since its the same code), and 2) couldn't it be
> allocated out of brk?

need to double check if we really need allocator_slop.
we only need to make sure init_memory_mapping() could get ram spaces that is already mapped for extra page tables.

YH
