Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYDJUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYDJUmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYDJUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:42:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54188 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbYDJUmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:42:46 -0400
Message-ID: <47FE7A6C.1070405@zytor.com>
Date: Thu, 10 Apr 2008 13:37:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor -- payload_length
References: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
In-Reply-To: <86802c440804101334j4b69373dv172ab72b072dc4a0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>>  FWIIW, i've been booting allyesconfig bzImages for a long time (with
>>  only minimal amount of drivers disabled - mostly old ISA ones that
>>  assume the presence of the real hardware), and they boot and work fine
>>  on both 32-bit and 64-bit typical whitebox PCs. That means huge bzImages
>>  that decompresses into a ~41 MB kernel image. I'd expect that to be a
>>  rather severe test of the decompressor.
> 
> payload_offset and payload_length in arch/x86/boot/head.S
> seems to be used by bootloader  to seat the bzImage.  or just use size
> of bzImage
> 

payload_offset/payload_length are used by loaders for nonstandard 
platform loaders which don't actually load a bzImage.

> long term, should add one field after payload_length like
> payload_unzip_length to make bootloader or kexec what buffer size
> needed.

You can look at the payload headers for that.

	-hpa
