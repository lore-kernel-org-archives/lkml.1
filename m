Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbYE2Ubg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbYE2Ubg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbYE2UbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:31:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254AbYE2UbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:31:04 -0400
Message-ID: <483F1276.30902@zytor.com>
Date: Thu, 29 May 2008 13:30:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Honor 'quiet' command line option in real mode	boot
 decompressor.
References: <1212082032-6167-1-git-send-email-krh@redhat.com>	 <1212082032-6167-2-git-send-email-krh@redhat.com>	 <483EF94F.7040403@zytor.com> <1212090939.6189.9.camel@gaara.bos.redhat.com>
In-Reply-To: <1212090939.6189.9.camel@gaara.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
>> You know... we already have a command-line parser in the real-mode part 
>> of the boot code, and it already extracts the "quiet" option: we should 
>> be able to do this by passing a bit in "loadflags" (bit 5 suggested.)
> 
> Hmm, as far as I understand the boot code, the decompressor consists of
> just head_32/64.S and misc.c plus the #included inflate.c and the
> compressed image in piggy.o.  In this environment there is no command
> line parser, it's only available once the image has been decompressed.

> Or are you suggesting parsing the "quiet" option in the bootloader and
> then setting the loadflags bit from there?  That's certainly doable, and
> I can update grub accordingly, but just parsing the command line seems
> like a simple, more local fix.  I don't have a strong preference,
> though.

I think you're missing something: the decompressor is the *second stage* 
of the boot code; the first stage is the real-mode code (arch/x86/boot). 
  I'm suggesting passing the flag from the real-mode code to the 
decompressor, not from the boot loader (in the common case.)

	-hpa
