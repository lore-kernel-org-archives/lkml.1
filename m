Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYE2T42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYE2T42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbYE2Tzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:55:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824AbYE2Tzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:55:44 -0400
Subject: Re: [PATCH 2/2] Honor 'quiet' command line option in real mode
	boot decompressor.
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <483EF94F.7040403@zytor.com>
References: <1212082032-6167-1-git-send-email-krh@redhat.com>
	 <1212082032-6167-2-git-send-email-krh@redhat.com>
	 <483EF94F.7040403@zytor.com>
Content-Type: text/plain; charset=utf8
Date: Thu, 29 May 2008 15:55:39 -0400
Message-Id: <1212090939.6189.9.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 11:43 -0700, H. Peter Anvin wrote:
> Kristian Høgsberg wrote:
> > This patch lets the early real mode decompressor parse the kernel
> > command line and look for the 'quiet' option.  When 'quiet' is passed
> > we suppress the "Decompressing Linux... Parsing ELF... done." messages.
> > 
> > This is in line with how the rest of the kernel suppresses informational
> > debug spew when quiet is given.
> > 
> > Signed-off-by: Kristian HÃ¸gsberg <krh@redhat.com>
> 
> You know... we already have a command-line parser in the real-mode part 
> of the boot code, and it already extracts the "quiet" option: we should 
> be able to do this by passing a bit in "loadflags" (bit 5 suggested.)

Hmm, as far as I understand the boot code, the decompressor consists of
just head_32/64.S and misc.c plus the #included inflate.c and the
compressed image in piggy.o.  In this environment there is no command
line parser, it's only available once the image has been decompressed.

Or are you suggesting parsing the "quiet" option in the bootloader and
then setting the loadflags bit from there?  That's certainly doable, and
I can update grub accordingly, but just parsing the command line seems
like a simple, more local fix.  I don't have a strong preference,
though.

cheers,
Kristian


