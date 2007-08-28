Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXH1Tf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXH1Tf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbXH1Tc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:32:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41468 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761332AbXH1Tc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:32:56 -0400
Date: Tue, 28 Aug 2007 21:34:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tom <fivemiletom@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 2.6.21.3] kbuild: fix build for cygwin
Message-ID: <20070828193416.GB32202@uranus.ravnborg.org>
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org> <4669A0BD.8050104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4669A0BD.8050104@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:32:29AM -0700, Tom wrote:
> From: Tom Enderes <enderes@gmail.com>
> 
> The kernel build failed on cygwin hosts, because cygwin has slightly 
> different typedefs compared to linux:
> scripts/mod/file2alias.c:518: error: dereferencing pointer to incomplete
> type
> Two files, scripts/mod/file2alias.c and scripts/mod/modpost.h, were 
> modified as follows:
> Whever __CYGWIN__ is defined, __uint32 is defined as __uint32_t (instead 
> of uint_32_t) and the missing ElfxxSection definitions are added.
> These changes have been tested both on cygwin 1.5.24, hostcc=gcc 3.4.4 
> and on FC5, hostcc=gcc 4.1.1-1. Any tests on cygwin, with and without 
> this change, were executed with the following set for make: 
> HOST_LOADLIBES="-lcurses -lintl".

Hi Tom.

I have revisited this and have made a successfull kernel build on a
windows/cygwin box now.

I had to change two things only:
1) The -lintl workaround was fixed by introducing a little script.
   If gcc cannot link a program that sues gettext then NLS is disabled.

2) Elf32_Section and Elf64_Section was replaced by Elfnn_Half

The build succeeds with a number of warnings that I just ignored.
fixdep and friends always get rebuild because kbuild does
not know about the .exe suffix so it does not
see that the binaries exists.
This is annoying and I hope to fix it before the merge.

These change will hit mainline during next merge window
so it will take a while before you can benefit.

For now they are in the kbuild.git tree at git.kernel.org
and will soon be part of -mm.

	Sam
