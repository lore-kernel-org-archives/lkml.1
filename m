Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYE2WZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYE2WZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbYE2WZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:25:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbYE2WZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:25:13 -0400
Subject: Re: [PATCH 2/2] Honor 'quiet' command line option in real
	mode	boot decompressor.
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <483F1276.30902@zytor.com>
References: <1212082032-6167-1-git-send-email-krh@redhat.com>
	 <1212082032-6167-2-git-send-email-krh@redhat.com>
	 <483EF94F.7040403@zytor.com> <1212090939.6189.9.camel@gaara.bos.redhat.com>
	  <483F1276.30902@zytor.com>
Content-Type: text/plain; charset=utf8
Date: Thu, 29 May 2008 18:25:06 -0400
Message-Id: <1212099906.5422.0.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 13:30 -0700, H. Peter Anvin wrote:
> Kristian Høgsberg wrote:
> >> You know... we already have a command-line parser in the real-mode part 
> >> of the boot code, and it already extracts the "quiet" option: we should 
> >> be able to do this by passing a bit in "loadflags" (bit 5 suggested.)
> > 
> > Hmm, as far as I understand the boot code, the decompressor consists of
> > just head_32/64.S and misc.c plus the #included inflate.c and the
> > compressed image in piggy.o.  In this environment there is no command
> > line parser, it's only available once the image has been decompressed.
> 
> > Or are you suggesting parsing the "quiet" option in the bootloader and
> > then setting the loadflags bit from there?  That's certainly doable, and
> > I can update grub accordingly, but just parsing the command line seems
> > like a simple, more local fix.  I don't have a strong preference,
> > though.
> 
> I think you're missing something: the decompressor is the *second stage* 
> of the boot code; the first stage is the real-mode code (arch/x86/boot). 
>   I'm suggesting passing the flag from the real-mode code to the 
> decompressor, not from the boot loader (in the common case.)

Indeed, I had it the wrong way around.  I like the bootflag approach,
updated patches coming up.

thanks,
Kristian


