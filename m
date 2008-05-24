Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYEXGUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYEXGUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYEXGUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:20:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYEXGUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:20:01 -0400
Message-ID: <4837B2DD.908@zytor.com>
Date: Fri, 23 May 2008 23:17:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use structs instead of hardcoded offsets in x86 boot
 decompressor.
References: <1211579968-15227-1-git-send-email-krh@redhat.com> <20080523210744.52fe7fde@bree.surriel.com>
In-Reply-To: <20080523210744.52fe7fde@bree.surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> 
> People who wonder why these pointers never get initialized: they
> point to the zeropage, which of course lives at address zero.
> 
> /* The so-called "zeropage" */
> struct boot_params {
> 	struct screen_info screen_info;                 /* 0x000 */
>         struct apm_bios_info apm_bios_info;             /* 0x040 */
>         __u8  _pad2[12];                                /* 0x054 */
>         struct ist_info ist_info;                       /* 0x060 */
> 	...
> 

Uhm... except it doesn't live at address zero, at all.

It's called "zeropage" because we used to recycle it into 
empty_zero_page, a long long time ago.

The bootparms structure is pointed to by %esi being passed from the 
setup code to the decompressor to the kernel.

	-hpa
